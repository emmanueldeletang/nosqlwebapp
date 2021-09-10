# -*- coding: utf-8 -*-
"""
@author: ede
"""
from flask import Flask, render_template,request,redirect,url_for # For flask implementation
from bson import ObjectId # For ObjectId to work
from pymongo import MongoClient
import json 
import os,sys
import boto3
from datetime import datetime
import random
from gremlin_python.process.anonymous_traversal import traversal
from gremlin_python.driver.driver_remote_connection import DriverRemoteConnection
from gremlin_python.structure.graph import Graph
from gremlin_python.process.graph_traversal import __
from gremlin_python import statics
from flask import jsonify
import random
import redis
from bson.json_util import dumps
from rediscluster import RedisCluster


statics.load_statics(globals())



# datetime object containing current date and time


app = Flask(__name__)

dynamodb = boto3.resource('dynamodb')
username = os.environ.get("username")
password = os.environ.get("password")
clusterendpoint = os.environ.get("clusterendpoint")
redishost = os.environ.get("rediscluster")

#emdelredis.0hokrt.ng.0001.euw3.cache.amazonaws.com



redisClient = redis.StrictRedis(host=redishost, port=6379, db=0 )

client = MongoClient(clusterendpoint, username=username, password=password, ssl='true', ssl_ca_certs='rds-combined-ca-bundle.pem',retryWrites='false')
db = client.restaurant  #Select the database
cmenu = db.menu #Select the collection name
od = db.orders


#dynamodb = boto3.resource('dynamodb',
#                    aws_access_key_id=keys.ACCESS_KEY_ID,
#                    aws_secret_access_key=keys.ACCESS_SECRET_KEY,
#                    aws_session_token=keys.AWS_SESSION_TOKEN)


from boto3.dynamodb.conditions import Key, Attr

email = "t@gmail.com"



# put in cache the menu 
def cacheredis(): 
    database = client.restaurant #database name in mongodb
    menu = database.menu.find({"active" : True}) #collection name database
    serializedObj = dumps(menu) #serialize object for the set redis.
    result = redisClient.set('menu', serializedObj) #set serialized object to redis server.
    parsedUserList = redisClient.get('menu')

  

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
        table = dynamodb.Table('userdata')
        
        table.put_item(
                Item={
        'name': name,
        'email': email,
        'password': password,
        'city': city #,
    #    'country':country
            }
        )
        msg = "Welcome to Restaurant GEMINA Registration Complete. Please Login to your account !"
    
        return render_template('login.html',msg = msg)
    return render_template('index.html')

@app.route('/login')
def login():    
    return render_template('login.html')


@app.route('/check',methods = ['post'])
def check():
    if request.method=='POST':
        global email
        email = request.form['email']
        password = request.form['password']
        
        table = dynamodb.Table('userdata')
        response = table.query(
                KeyConditionExpression=Key('email').eq(email)
        )
        items = response['Items']
        name = items[0]['name']

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
       now = datetime.now()
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
      

       ip =  request.environ.get('HTTP_X_REAL_IP', request.remote_addr) 
       foo = ['Paris', 'Bordeaux', 'Lyon', 'Valence', 'Clermont','Tunis']
       city = random.choice(foo)
       
     
         
       ordertoload = {"date": now  ,"amount": ordersspend, "country":city,"ip":ip,"orderdetails":[]}


       od.update_one({"email": email},
                {"$addToSet": {"orders": ordertoload}})

       for me in cmenu.find(querycommand):
           od.update_one({"email":email , "orders.date":now},
                           {"$push": {"orders.$[].orderdetails": me}})

       
       det = od.find({"email": email})
       load_neptune(email, ip,city)
       return render_template("order.html", email = email, det = det)

    

    menu_l = cmenu.find({"active": True})
    return render_template("home.html",menus=menu_l,  email = email)
  
  

    
def load_neptune(email,ip,city):
    
   
    
    endpoint = os.environ["NEPTUNE_ENDPOINT"]
    g = traversal().withRemote(
    DriverRemoteConnection(f"wss://{endpoint}:8182/gremlin", "g")
    )
    
   
    try :
        g.addV('User').property(id,email).property('username', email).next()
    except :
       pass 
    try :
        g.addV('city').property(id,city).property('cityname', city).next()
    except :
       pass 
    try :
        g.addV('IPAddress').property(id, ip).property('address', ip).next()
    except :
       pass 
    try :
        g.V(ip).addE('Used').to(__.V(email)).property('use',ip).next()
    except :
        pass 
    try :
        g.V(email).addE('lived').to(__.V(city)).property('live',city).next()
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
      
       endpoint = os.environ["NEPTUNE_ENDPOINT"]
       g = traversal().withRemote(
       DriverRemoteConnection(f"wss://{endpoint}:8182/gremlin", "g")
       )
    
       sup = g.V(ip).flatMap(outE('Used').inV()).path().by(valueMap('username')).toList()
       sup = [[i for i in nested if i != 'path[{}'] for nested in sup]
       
       new_k = []
       for elem in sup:
          if elem not in new_k:
           new_k.append(elem)
       sup = new_k
       sup = [i[1:] for i in sup]

       
       cit = g.V(email).flatMap(outE('lived').inV()).path().by(valueMap('cityname')).toList()
       cit =   [[i for i in nested if i != 'path[{}'] for nested in cit]
       new = []
       for elem in cit:
          if elem not in new:
           new.append(elem)
       cit = new
       cit = [i[1:] for i in cit]

       
    
       
 

    cacheredis()
    return render_template("fraud.html", email = email, ip = ip ,  sup = sup , cit = cit)


@app.route('/cache', methods=['POST'])
def cache():
    
    if request.method=='POST':
        time1 = datetime.now()
        List = redisClient.get('menu')
        time2= datetime.now()
        t = time2 - time1
        parsedUserList = json.loads(List)
        

        
    return render_template("cache.html", email = email,  menus = parsedUserList ,t=t)
    

    
    

if __name__ == "__main__":
    
    app.run(host='0.0.0.0', port=8080, debug=True)

