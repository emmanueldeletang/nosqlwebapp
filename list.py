import json 
import os,sys
import random

fruits = [[{'username': ['t@gmail.com']}, {'username': ['Undefined']}],
[{'username': ['t@gmail.com']}, {'username': ['Undefined']}],
[{'username': ['t@gmail.com']}, {'username': ['Undefined']}],
[{'username': ['t@gmail.com']}, {'username': ['Undefined']}],
[{'username': ['t@gmail.com']}, {'username': ['Undefined']}],
[{'username': ['t@gmail.com']}, {'username': ['Undefined']}],
[{'username': ['t@gmail.com']}, {'username': ['Lyon']}]]

new_k = []


for elem in fruits:
    if elem not in new_k:
        new_k.append(elem)
k = new_k


result = [i[1:] for i in k]

print (result)


