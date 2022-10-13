# -*- coding: utf-8 -*-
"""
@author: ede
"""
from multiprocessing.connection import Client
from telnetlib import IP
from typing import Container
from flask import Flask, render_template,request,redirect,url_for # For flask implementation
from bson import ObjectId # For ObjectId to work
import pymongo 
import json 
import os,sys
import random
from gremlin_python.process.anonymous_traversal import traversal
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
import gremlin_python.driver
from gremlin_python.driver import client, serializer
from gremlin_python import statics
from flask import jsonify
import random
from bson.json_util import dumps
import uuid
import azure.cosmos.documents as documents
import azure.cosmos.cosmos_client as cosmos_client
import azure.cosmos.exceptions as exceptions
from azure.cosmos.partition_key import PartitionKey
import config
import datetime
import socket    


now = datetime.datetime.now()




statics.load_statics(globals())



# datetime object containing current date and time


app = Flask(__name__)

HOST = config.settings['host']
MASTER_KEY = config.settings['master_key']
DATABASE_ID = config.settings['database_id']
CONTAINER_ID = config.settings['container_id']
gremlinuri = config.settings['gremlinsuri']

  

clientg =  client.Client(gremlinuri , 'g',
                           username=config.settings['gremlinsdb'],
                           password=config.settings['gremlinskey'],
                           message_serializer=serializer.GraphSONSerializersV2d0()
                           )


clients = cosmos_client.CosmosClient(HOST, {'masterKey': MASTER_KEY}, user_agent="CosmosDBPythonQuickstart", user_agent_overwrite=True)
db = clients.get_database_client(DATABASE_ID)
container = db.get_container_client(CONTAINER_ID)

uriconnect =   config.settings['uriconnect']
client = pymongo.MongoClient(uriconnect)

print(uriconnect)

db = client.restaurant  #Select the database
cmenu = db.menu #Select the collection name
od = db.orders



email = "t@gmail.com"




@app.route('/')
def index():
   return render_template('index.html')


@app.route('/manage',methods=["POST","GET"])
def manage():
   
    if request.method=='POST':
       cmenu.update_many({},{"$set": {"active":False}},upsert=False)
       
       command = request.form.getlist("mycheck")
       querycommand = {"id": {"$in": command}}
       me = cmenu.find(querycommand)
       for me in cmenu.find(querycommand):
          cmenu.update_one( me,{"$set": {"active":True}},  upsert=False)

       menu_l = cmenu.find().sort("type", -1)
       return render_template("manage.html",menus = menu_l )
        
    menu_l = cmenu.find().sort("type",-1)
    return render_template("manage.html",menus = menu_l)
    





@app.route('/signup', methods=['post'])
def signup():
    if request.method == 'POST':
        name = request.form['name']
        global email
        email = request.form['email']
        password = request.form['password']
        city = request.form['city']
     #   country = request.form['country']
         
        Item={
        'id' : str(uuid.uuid4()),
        'name': name,
        'email': email,
        'password': password,
        'city': city #,
    #    'country':country
            }
 
       
     
        container.upsert_item(body=Item)
        
    
        msg = "Welcome to Restaurant GEMINA Registration Complete. Please Login to your account !"
    
        return render_template('login.html',msg = msg)
    return render_template('index.html')

@app.route('/login')
def login():    
    return render_template('login.html')

def query_items(container, email):
   
  
    # Including the partition key value of account_number in the WHERE filter results in a more efficient query
    items = list(container.query_items(
        query="SELECT * FROM r WHERE r.email=@email",
        parameters=[
            { "name":"@email", "value":email }
        ]
    ))
    print(items)
    return items

@app.route('/check',methods = ['post'])
def check():
    if request.method=='POST':
        global email
        email = request.form['email']
        password = request.form['password']
        
        print (email)
        items = list(container.query_items(
        query="SELECT * FROM r WHERE r.email=@email",
        parameters=[
            { "name":"@email", "value":email }
        ]
         ))
               
        name = items[0]['name']
        print(items[0]['password'])

        if password == items[0]['password']:
            
            menu_l = cmenu.find({"active" : True , "type":"starter"})
            menu_m = cmenu.find({"active" : True , "type":"main"})
            menu_d = cmenu.find({"active" : True , "type":"dessert"})
            
            
            
         #    menu_l = client['restaurant']['menu'].aggregate([{'$match': {'active': True}}, {'$sort': {'type': -1}}])
            return render_template("home.html",menus = menu_l,main = menu_m ,des = menu_d, email = email   )

    menu_l = cmenu.find({"active": True} )
    return render_template("home.html",menus = menu_l, email = email)

@app.route('/home',methods=["POST","GET"])
def home():
    if request.method=='POST':
       
       command = request.form.getlist("mycheck")
       querycommand = {"name": {"$in": command}}
       me = cmenu.find(querycommand)
       now = datetime.datetime.now()
       nborder = 0
       totalspend = 0

       for o in  od.find({"email":email}):
            nborder = o["nborder"]
            totalspend = o["totalspend"]

       nborder = nborder + 1
       ordersspend= 0

       for me in cmenu.find(querycommand):
            ordersspend = ordersspend + int( me["price"])

       totalspend = totalspend + ordersspend

       od.update_one({"email": email},
                     {"$set": {"email": email,
                            "nborder": nborder,
                            "lastorder":now,
                            "totalspend":totalspend}},  upsert=True
                     )
      

       
       hostname = socket.gethostname()    
       IPAddr = socket.gethostbyname(hostname)    
       print("Your Computer Name is:" + hostname)    
       print("Your Computer IP Address is:" + IPAddr)
       ip = IPAddr




       foo = ['Paris', 'Bordeaux', 'Lyon', 'Toulouse', 'Clermont','Tunis','Bruxelles','Doha']
       city = random.choice(foo)
       
     
         
       ordertoload = {"date": now  ,"amount": ordersspend, "country":city,"ip":ip,"orderdetails":[]}


       od.update_one({"email": email},
                {"$addToSet": {"orders": ordertoload}})

       for me in cmenu.find(querycommand):
           od.update_one({"email":email , "orders.date":now},
                           {"$push": {"orders.$[].orderdetails": me}})

       
       det = od.find({"email": email})

       try :
         
         load_neptune(email, ip,city)
         re = executeGremlinQuery("g.V().has('label','IPAddress').limit(10)")

       except :
            pass 
    
 
       print(re)
       return render_template("order.html", email = email, det = det, re = re)

    

    menu_l = cmenu.find({"active": True})
    return render_template("home.html",menus=menu_l,  email = email)
  
  

cosmosdb_messages = {
    409: 'Conflict exception. You\'re probably inserting the same ID again.',
    429: 'Not enough RUs for this query. Try again.'
}

def executeGremlinQuery(gremlinQuery, message=None, params=None):
    try: 
        callback = clientg.submitAsync(gremlinQuery)
        if callback.result() is not None:
            return callback.result().one()
    except GremlinServerError as ex:
        status=ex.status_attributes['x-ms-status-code']
        print('There was an exception: {0}'.format(status))
        print(cosmosdb_messages[status])
    
def load_neptune(email,ip,city):
    
    

    print ("gremlins commande")

    cmdemail = "g.addV('User').property('id','"+email+"').property('part','"+email+"').property('username', '"+email+"')"


    try :
       executeGremlinQuery( cmdemail)
    except :
       pass 
    try :
       cmdcity = "g.addV('city').property('id','"+city+"').property('part','"+city+"').property('cityname', '"+city+"')"
      
       executeGremlinQuery( cmdcity)
    except :
       pass 
    try :
       cmdip = "g.addV('IPAddress').property('id','"+ip+"').property('part','"+ip+"').property('cityname', '"+ip+"')"
       print (cmdip)
       executeGremlinQuery( cmdip)
    except :
       pass 
    try :
        cmdused = "g.V('"+ip+"').addE('Used').to(__.V('"+email+"')).property('use','"+ip+"')"
        print (cmdused)
        executeGremlinQuery( cmdused)
    except :
        pass 
    try :
       cmdlived = "g.V('"+email+"').addE('lived').to(__.V('"+city+"')).property('live','"+ip+"')"
       print (cmdlived)
       executeGremlinQuery( cmdlived)
    except :
        pass 
    
  

        
    
@app.route('/order')
def order():
    if request.method=='POST':
       return render_template("fraud.html", email = email)

    return render_template("order.html", email = email)
    


@app.route('/fraud', methods=['POST'])
def fraud():
    if request.method=='POST':
       ip = request.form["IP"]   
       supcmd= "g.V('"+ip+"').flatMap(outE('Used').inV()).dedup().path().by(valueMap('username'))"
       print (supcmd)
       
       supRES = executeGremlinQuery( supcmd)
       print(supRES)
       sup = ''
       for su in supRES :
            for s in (su["objects"]):
                if len(s) == 1 :
                    sup = sup + str(s)
       
       citres = executeGremlinQuery( "g.V('"+email+"').flatMap(outE('lived').inV()).dedup().path().by(valueMap('cityname'))")
       print (citres)
       cit = ''
       for ci in citres :
            for s in (ci["objects"]):
                if len(s) == 1 :
                    cit = cit + str(s)
       
   
                    
 

    # cacheredis()
    return render_template("fraud.html", email = email, ip = ip ,  sup = sup , cit = cit)

#
#@app.route('/cache', methods=['POST'])
#def cache():
    
 #   if request.method=='POST':
 #       time1 = datetime.now()
 #       List = redisClient.get('menu')
 #       time2= datetime.now()
 #       t = time2 - time1
  #      parsedUserList = json.loads(List)
        

        
  #  return render_template("cache.html", email = email,  menus = parsedUserList ,t=t)
    

    
    

if __name__ == "__main__":
    
    app.run(host='0.0.0.0', port=8080, debug=True)

