import * as cdk from 'aws-cdk-lib';
import { readFileSync } from 'fs';


import { KeyPair } from 'cdk-ec2-key-pair';
import { Construct } from 'constructs';


export class noSqlDemoStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // Create a Key Pair to be used with ASG EC2 Instance
    const key = new KeyPair(this, 'keypair', {
      name: 'keypair',
      description: 'Key Pair for nosqlDemo acces to flask app',
      storePublicKey: true,
      secretPrefix: '/nosqldemo/ec2/'
    });
    key.grantReadOnPublicKey;

    // Create new VPC with 2 Subnets type
    const vpc = new cdk.aws_ec2.Vpc(this, 'VPC', {
      natGateways: 0,
      cidr: '10.0.0.0/24',
      maxAzs: 2,
      subnetConfiguration: [{
        cidrMask: 28,
        name: "publicSub",
        subnetType: cdk.aws_ec2.SubnetType.PUBLIC
      },
      {
        cidrMask: 28,
        name: 'privateSub',
        subnetType: cdk.aws_ec2.SubnetType.PRIVATE_ISOLATED,
      }]
    });

    // Security Group WebApp app (allowing port 80 & 22)
    const sgWebApp = new cdk.aws_ec2.SecurityGroup(this, 'sgWebApp', {
      vpc,
      description: 'Allow SSH (TCP port 22 and 80) in',
      allowAllOutbound: true
    });
    sgWebApp.addIngressRule(cdk.aws_ec2.Peer.anyIpv4(), cdk.aws_ec2.Port.tcp(22), 'Allow SSH Access');
    sgWebApp.addIngressRule(cdk.aws_ec2.Peer.anyIpv4(), cdk.aws_ec2.Port.tcp(8080), 'Allow HTTP Access');

    //adding role to WebApp instances to use SSM Agent & get secrets from manager
    const WebAppRole = new cdk.aws_iam.Role(this, 'WebAppRole', {
      assumedBy: new cdk.aws_iam.ServicePrincipal('ec2.amazonaws.com'),
      maxSessionDuration: cdk.Duration.hours(12)

    })
    WebAppRole.addManagedPolicy(cdk.aws_iam.ManagedPolicy.fromAwsManagedPolicyName('AmazonSSMFullAccess'));
    WebAppRole.addManagedPolicy(cdk.aws_iam.ManagedPolicy.fromAwsManagedPolicyName('SecretsManagerReadWrite'));



    // Use Latest Amazon Linux Image - CPU Type ARM64
    const ami = new cdk.aws_ec2.AmazonLinuxImage({
      generation: cdk.aws_ec2.AmazonLinuxGeneration.AMAZON_LINUX_2,
      cpuType: cdk.aws_ec2.AmazonLinuxCpuType.X86_64,
    });
    // Create the instance using the Security Group, AMI, and KeyPair defined in the VPC created
    const userdata_file = readFileSync('lib/user-data.sh', 'utf-8');

    const ec2Instance = new cdk.aws_ec2.Instance(this, 'ec2-instance', {
      vpc,
      vpcSubnets: {
        subnetType: cdk.aws_ec2.SubnetType.PUBLIC,
      },
      instanceType: cdk.aws_ec2.InstanceType.of(cdk.aws_ec2.InstanceClass.T2, cdk.aws_ec2.InstanceSize.MICRO),
      machineImage: ami,
      securityGroup: sgWebApp,
      keyName: key.keyPairName,
      role: WebAppRole,
      userData: cdk.aws_ec2.UserData.forLinux({
        shebang: userdata_file || ""
      })
    });



    redisStack(this, vpc);

    neptuneStack(this, vpc);

    documentDBStack(this, vpc);

    RdsStack(this, vpc);

    DynamoDBStack(this, vpc, WebAppRole);



    // Create outputs for connecting
    //new cdk.CfnOutput(this, 'IP Address', { value: ec2Instance.instancePublicIp });
    // new cdk.CfnOutput(this, 'Key Name', { value: key.keyPairName })
    new cdk.CfnOutput(this, 'Download Key Command', { value: 'aws secretsmanager get-secret-value --secret-id /nosqldemo/ec2/keypair/private --query SecretString --output text > cdk-key.pem && chmod 400 cdk-key.pem' })
    new cdk.CfnOutput(this, 'ssh command', { value: 'ssh -i cdk-key.pem -o IdentitiesOnly=yes ec2-user@' + ec2Instance.instancePublicIp })
    new cdk.CfnOutput(this, 'application link', { value: ec2Instance.instancePublicDnsName + ':8080' })

  }
}

function DynamoDBStack(scope: Construct, vpc: cdk.aws_ec2.Vpc, granty: cdk.aws_iam.IGrantable) {

  const keySchemaProperty: cdk.aws_dynamodb.CfnTable.KeySchemaProperty = {
    attributeName: 'email',
    keyType: 'HASH',
  };

  const attributeDefinitionProperty: cdk.aws_dynamodb.CfnTable.AttributeDefinitionProperty = {
    attributeName: 'email',
    attributeType: 'S',
  };


  const table = new cdk.aws_dynamodb.Table(scope, 'DynamoDBTable', {
    partitionKey: { name: 'email', type: cdk.aws_dynamodb.AttributeType.STRING },
    tableName: 'userdata',
    readCapacity: 5,
    writeCapacity: 5,
    removalPolicy: cdk.RemovalPolicy.DESTROY
  });

  table.grantFullAccess(granty);

  new cdk.aws_ssm.StringParameter(scope, 'Parameter-dynamo-tablename', {
    description: 'The dynamoDB table name',
    parameterName: 'dynamo-table',
    stringValue: 'userdata'
  });

}

function RdsStack(scope: Construct, vpc: cdk.aws_ec2.Vpc) {

  const engine = cdk.aws_rds.DatabaseInstanceEngine.mysql({ version: cdk.aws_rds.MysqlEngineVersion.VER_8_0_21 });
  const rdsinstance = new cdk.aws_rds.DatabaseInstance(scope, 'rds-instance', {
    engine,
    vpc,
    vpcSubnets: {
      subnetType: cdk.aws_ec2.SubnetType.PRIVATE_ISOLATED,
    },
    credentials: cdk.aws_rds.Credentials.fromGeneratedSecret('admin', {
      secretName: '/nosqldemo/rds/masteruser'
    }), // Creates an admin user of postgres with a generated password
    instanceType: cdk.aws_ec2.InstanceType.of(
      cdk.aws_ec2.InstanceClass.BURSTABLE3,
      cdk.aws_ec2.InstanceSize.MICRO,
    ),
    multiAz: true,
    allocatedStorage: 100,
    autoMinorVersionUpgrade: true,
    deleteAutomatedBackups: true,
    removalPolicy: cdk.RemovalPolicy.DESTROY,
    deletionProtection: false,
    databaseName: 'rdsnosqldemo',
    publiclyAccessible: false,

  });

  new cdk.aws_ssm.StringParameter(scope, 'Parameter-rds-endpoint', {
    description: 'The RDS endpoint',
    parameterName: 'rds-endpoint',
    stringValue: rdsinstance.instanceEndpoint.hostname,
  });



}

function documentDBStack(scope: Construct, vpc: cdk.aws_ec2.Vpc) {


  const docdbCluster = new cdk.aws_docdb.DatabaseCluster(scope, 'docdb-cluster', {
    masterUser: {
      username: 'myuser', // NOTE: 'admin' is reserved by DocumentDB
      excludeCharacters: '\"@/:', // optional, defaults to the set "\"@/" and is also used for eventually created rotations
      secretName: '/nosqldemo/docdb/masteruser', // optional, if you prefer to specify the secret name
    },
    instanceType: cdk.aws_ec2.InstanceType.of(cdk.aws_ec2.InstanceClass.R5, cdk.aws_ec2.InstanceSize.LARGE),
    instances: 2,
    vpcSubnets: {
      subnetType: cdk.aws_ec2.SubnetType.PUBLIC,
    },
    vpc,
    removalPolicy: cdk.RemovalPolicy.DESTROY,
    deletionProtection: false
  });

  docdbCluster.connections.allowFrom(cdk.aws_ec2.Peer.ipv4('10.0.0.0/24'), cdk.aws_ec2.Port.tcp(27017), 'Allow mongo api Access');

  new cdk.aws_ssm.StringParameter(scope, 'Parameter-docdb-endpoint', {
    description: 'The docDB endpoint',
    parameterName: 'docdb-endpoint',
    stringValue: docdbCluster.clusterEndpoint.hostname,
  });

}

function neptuneStack(scope: Construct, vpc: cdk.aws_ec2.Vpc) {

  //Create a Neptune Subnet Group
  const neptunesubnetgroup = new cdk.aws_neptune.CfnDBSubnetGroup(scope, 'neptune-subnet-group', {
    dbSubnetGroupName: 'neptune-subnet-group',
    dbSubnetGroupDescription: 'The neptune subnet group id',
    subnetIds: vpc.isolatedSubnets.map(subnet => subnet.subnetId)

  });

  // The security group that defines network level access to the cluster
  const neptunesecuritygroup = new cdk.aws_ec2.SecurityGroup(scope, 'sg-neptune', {
    vpc,
    description: 'neptune-security-group',
    allowAllOutbound: true
  });
  neptunesecuritygroup.addIngressRule(cdk.aws_ec2.Peer.anyIpv4(), cdk.aws_ec2.Port.tcp(8182), 'Allow neptune Access');






  const neptunecluster = new cdk.aws_neptune.CfnDBCluster(scope, 'neptune-cluster', /* all optional props */ {

    iamAuthEnabled: false,
    dbSubnetGroupName: neptunesubnetgroup.dbSubnetGroupName?.toLowerCase(),
    vpcSecurityGroupIds: [neptunesecuritygroup.securityGroupId],
    dbClusterIdentifier: 'my-cluster'

  });

  neptunecluster._addResourceDependency(neptunesubnetgroup);

  const neptuneinstance = new cdk.aws_neptune.CfnDBInstance(scope, 'neptune-instance', {
    dbInstanceClass: 'db.t3.medium',

    // the properties below are optional
    allowMajorVersionUpgrade: false,
    autoMinorVersionUpgrade: false,
    dbClusterIdentifier: neptunecluster.dbClusterIdentifier
  });

  neptuneinstance.addDependsOn(neptunecluster);

  new cdk.aws_ssm.StringParameter(scope, 'Parameter-neptune-endpoint', {
    description: 'The Neptune endpoint',
    parameterName: 'neptune-endpoint',
    stringValue: neptunecluster.attrEndpoint
  });


}

function redisStack(scope: Construct, vpc: cdk.aws_ec2.Vpc) {
  //***** */
  //
  // REDIS WORKFLOW
  //
  //***** */

  //Create an ElastiCache Redis Replication group 


  const redisSubnetGroup = new cdk.aws_elasticache.CfnSubnetGroup(scope, 'redis-group', {
    cacheSubnetGroupName: 'redis-group',
    description: 'The redis subnet group id',
    subnetIds: vpc.isolatedSubnets.map(subnet => subnet.subnetId)
  });

  // The security group that defines network level access to the cluster
  const redisSecurityGroup = new cdk.aws_ec2.SecurityGroup(scope, 'sgRedis', {
    vpc,
    description: 'redis-security-group',
    allowAllOutbound: true
  });
  redisSecurityGroup.addIngressRule(cdk.aws_ec2.Peer.anyIpv4(), cdk.aws_ec2.Port.tcp(6379), 'Allow SSH Access');




  const redisReplicationGroup = new cdk.aws_elasticache.CfnReplicationGroup(
    scope,
    `redis-cluster`,
    {
      engine: "redis",
      cacheNodeType: "cache.t2.micro",
      replicasPerNodeGroup: 1,
      numNodeGroups: 1,
      multiAzEnabled: true,
      port: 6379,
      automaticFailoverEnabled: true,
      autoMinorVersionUpgrade: true,
      replicationGroupDescription: "cluster redis",
      cacheSubnetGroupName: redisSubnetGroup.cacheSubnetGroupName,
      securityGroupIds: [redisSecurityGroup.securityGroupId]
    }
  );
  redisReplicationGroup.addDependsOn(redisSubnetGroup);


  new cdk.aws_ssm.StringParameter(scope, 'Parameter-redis-endpoint', {
    description: 'The redis endpoint',
    parameterName: 'redis-endpoint',
    stringValue: redisReplicationGroup.attrPrimaryEndPointAddress
  });

  //***** */
  //END REDIS
  //***** */


}
