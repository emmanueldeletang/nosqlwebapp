import os

settings = {
    'host': os.environ.get('ACCOUNT_HOST', 'https://xxxxx.documents.azure.com:443/'),
    'master_key': os.environ.get('ACCOUNT_KEY', 'xxxx'),
    'database_id': os.environ.get('COSMOS_DATABASE', 'gemina'),
    'container_id': os.environ.get('COSMOS_CONTAINER', 'user'),
    'uriconnect' : os.environ.get('COSMOS_mongo','mongodb://dxxxxxx.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@demomongoapiedeletang@'),
    'gremlinsuri' : os.environ.get('gremlinsuri','wss://xxxxx.gremlin.cosmos.azure.com:443/'),
    'gremlinskey': os.environ.get('gremlinskey', 'xxxxxuaAWRuZkZQb4L4P4et3ntD8esMrZWeQ=='),
    'gremlinsdb': os.environ.get('gremlinsdb', '/dbs/gemina/colls/restaurant'),
   '  KEY': os.environ.get('KEY', 'XXXX'),
    'ENDPOINT': os.environ.get( 'ENDPOINT','https://api.cognitive.microsofttranslator.com/'),
    'LOCATION': os.environ.get('LOCATION','francecentral')
  
}