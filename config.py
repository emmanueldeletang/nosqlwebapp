import os

settings = {
    'host': os.environ.get('ACCOUNT_HOST', 'https://demoedeletang.documents.azure.com:443/'),
    'master_key': os.environ.get('ACCOUNT_KEY', 'CmwT2GnQgDS555a0Q9y0DcXZNs4rfYQNJQbyztUsVdj2k0jDXX4pHi2Ft6CkkzdKGEqtXIufQksADcxQDdMy0Q=='),
    'database_id': os.environ.get('COSMOS_DATABASE', 'gemina'),
    'container_id': os.environ.get('COSMOS_CONTAINER', 'user'),
    'uriconnect' : os.environ.get('COSMOS_mongo','mongodb://demomongoapiedeletang:ryekmAGmmOLHNfDqkcf5RVIyfevIGcmiNRyN5zp8v2K8oDoj8ceNEV3tXWdVh0TAE4CkVQbbenLgzulzEutIQA==@demomongoapiedeletang.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@demomongoapiedeletang@'),
    'gremlinsuri' : os.environ.get('gremlinsuri','wss://edeletangdemograph.gremlin.cosmos.azure.com:443/'),
    'gremlinskey': os.environ.get('gremlinskey', 'KNHPnGDC29RWiQZ6q4awz7B6fdWiVi7IBBWVlmeOWxzz210yJz5qii5uaAWRuZkZQb4L4P4et3ntD8esMrZWeQ=='),
    'gremlinsdb': os.environ.get('gremlinsdb', '/dbs/gemina/colls/restaurant'),
  
}