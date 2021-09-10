---
page_type: sample
languages:
- python
products:
- AWS DocumentDB , AWS dynamodb , AWS elastic cache , AWS neptune 
description: "This sample demonstrates a Python application that will manage restaurant application using different nosql technologies  "

---
# Build a website with nosql database exemple 

## About this sample

> This sample is a web site using different technologies to resolve different use case when you build a web application using different AWS services 
    
### Overview

This sample demonstrates a Python application with FLASK ( this is a sample , you can make in other langage the same no problem ) 

This sample is a web site using different technologies to resolve different use case when you build a web application 
    Having an authentification module ( register , login management ... ) 
    Purpose menu/ Product to select ( with admin part and user part ) 
    Store all the orders ( base on command by user , make simple stat ( number of order , amount spend ... ) 
    Having a fraud suspicious detection ( having the possiblity to detect a fraud , load the order  in bussiness logic different ) 
    Accelerate you web page with caching ( the product or menu are ofter load so how to optimize this 

WELCOME to Gemina trattoria  ( why gemina , this was the name of by Granf mother who teach me how to cook , and she was an incredible mediteranean grand mother with all the advantage you can imagine for his grandchildren) 


## How to run this sample

To run this sample, you'll need:

> [Python 3+](https://www.python.org/downloads/release/python-364/)

> - An AWS account where you will create 
>     A cloud 9 environement to interact ( or you can install all in an EC2 ) 
>     A AWS Dynamodb table 
>     A AWS DocumentDB table 
>     A AWS Neptune cluster 
>     A elastic cache Redis cluster 
>     A s3 to store the image load in the web site 
> 

### Step 1:  Clone or download this repository

From your shell or command line:

```Shell
git clone https://github.com/emmanueldeletang/nosqlwebapp/
```

or download and extract the repository .zip file.

> Given that the name of the sample is quite long, you might want to clone it in a folder close to the root of your hard drive, to avoid file name length limitations when running on Windows.

### Step 2:  install the pre-requisite python library 


Setup your AWS credentials in the cloud9 or EC2 shell using 
  AWS configure  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html

- You will need to install dependencies using pip as follows:
install 
  Gremlins , pymongo , redis , boto3  
  
 you can use the following command : 
```Shell
$ python -m pip install - r requirement.txt 

```
>     A AWS Dynamodb table  
```Shell
python dynamoDB_create_table.py 
```

>     A AWS DocumentDB cluster https://docs.aws.amazon.com/documentdb/latest/developerguide/get-started-guide.html#cloud9-cluster
>     A AWS Neptune cluster https://docs.aws.amazon.com/neptune/latest/userguide/get-started-create-cluster.html
>     A elastic cache Redis cluster https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/GettingStarted.CreateCluster.html
>     A s3 to store the image load in the web site  https://docs.aws.amazon.com/AmazonS3/latest/userguide/creating-bucket.html

Setup your AWS credentials in the cloud9 or EC2 shell using 
  AWS configure 

- You will need to install dependencies using pip as follows:
install 
  Gremlins , pymongo , redis , boto3  
  
 you can use the following command : 
```Shell
$ python -m pip install - r requirement.txt 

```

In the shell configure all the global information ( your neptune enpoint , password document .... ) 
```Shell
$ export NEPTUNE_ENDPOINT=XXXXXXXXX.neptune.amazonaws.com
$ export password=XXXXX
$ export  rediscluster=XXXXXXX.cache.amazonaws.com
$ export username=XXXXX
$ export clusterendpoint=XXXXX.docdb.amazonaws.com:27017


```

load some information in menu collection a sample is here you can load menu.json file , this is a sample to load in your menu , but you can load what you want , just check the url of image of course and use your own S3 . 



### Step 3:  Run the application  

Run ..... 

```Shell
$ python app.py 

--- 

this will launch a http web site on the url of you EC2 or cloug 9  

a sample of application can be accessible on the following address http://ec2-35-180-230-131.eu-west-3.compute.amazonaws.com:8080/


 more information will arrive in the future 


