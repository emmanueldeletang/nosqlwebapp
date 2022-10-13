---
page_type: sample
languages:
- python
products:
- Azure CosmsosDB 
description: "This sample demonstrates a Python application that will manage restaurant application using different type of nosql technologies  "

---
# Build a website with nosql database exemple 

## About this sample

> This sample is a web site using different technologies to resolve different use case when you build a web application using different azure cosmsodb  technologies 
    
### Overview

This sample demonstrates a Python application with FLASK ( this is a sample , you can make in other langage the same no problem ) 

This sample is a web site using different technologies to resolve different use case when you build a web application 
    Having an authentification module ( register , login management ... ) 
    Purpose menu/ Product to select ( with admin part and user part ) 
    Store all the orders ( base on command by user , make simple stat ( number of order , amount spend ... ) 
    Having a fraud suspicious detection ( having the possiblity to detect a fraud , load the order  in bussiness logic different ) 
    
WELCOME to Gemina trattoria  ( why gemina , this was the name of my Grand mother who teach me how to cook , and she was an incredible mediteranean grand mother with all the advantage you can imagine for his grandchildren) 


## How to run this sample

To run this sample, you'll need:

> An Azure subscription




### Step 1:  Clone this repository

From your shell or command line:

```Shell
$ git clone https://github.com/emmanueldeletang/nosqlwebappcosmosdb/
```


### Step 2:  Customize the menu

Open the Menu.json file and see a menu collection sample. 
You can modify the items to load your menu in the application. Make sure to check the url of the image for each meal. You can use your own azure storage to load meal's images.



### Step 3:  Install pre requis 
 
For the moment you need to create 3 Cosmsodb account ( of course this is for the sample and to show you how simple is it to )
    one SQL 
    one Mongo API 
    one Gremlins 
    one storage account to have the image 

    Setup all the connection string in config.py from your Gremlins , mongo api and cosmosdb API 

if you want to load the menu you can use a mongoimport command from the menu.json sample in the directory 
You need to create a cosmosdb container in SQL api name User and with the partition key (email )

### Step 4:  Access the demo application Gemina

in the directory launch pythonh APP.py and the web site will be launch 

you can deploy in a web app too if you want 


