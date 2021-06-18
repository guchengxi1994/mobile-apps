'''
Descripttion: 
version: 
Author: xiaoshuyui
email: guchengxi1994@qq.com
Date: 2021-06-16 19:11:42
LastEditors: xiaoshuyui
LastEditTime: 2021-06-16 19:41:07
'''
import json
import requests
import base64

dic = dict()
dic['image1'] = ''
dic['image2'] = ''

with open("d:\\Desktop\\1562663241_794834_2.jpg",'rb') as f1:
    base64_data1 = base64.b64encode(f1.read())
    # print(base64_data1)
    dic['image1'] = base64_data1.decode("utf-8")

with open("d:\\Desktop\\1562663171_562012_2.jpg",'rb') as f2:
    base64_data1 = base64.b64encode(f2.read())
    #  print(base64_data1)
    dic['image2'] = base64_data1.decode("utf-8")

r  = requests.post("http://127.0.0.1:3334/compare",data=json.dumps(dic))

# print(dic)

print(r)
print(r.text)