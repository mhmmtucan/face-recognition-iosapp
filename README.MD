# Face Recognition iOS APP Example Using API
![](https://travis-ci.org/mhmmtucan/face-recognition-iosapp.svg?branch=master) [![GitHub license](https://img.shields.io/github/license/mhmmtucan/face-recognition-iosapp.svg)](https://github.com/mhmmtucan/face-recognition-iosapp/blob/master/LICENSE) 

This repository provides a working sample of face recognition system which is built to be a second factor 
of a two factor authentication. [Kairos API](https://www.kairos.com/) used for face detection and recognition. By using this sample someone can analyze Kairos API and face recognition function in thier iOS environment. 

# Getting Started

## Prerequisites
* 	Download zip or clone, then directly use.
* 	Developed using Xcode 9.1, iOS 11.1 and Swift 4
*	SwiftJSON framework is used for handling JSON.

## Installing
In order to use API, App ID and key is needed. This variables have to be provided from Kairos web page. After that have to be inserted in code.
    
```
request.addValue("APPKEY_HERE", forHTTPHeaderField: "app_key")
request.addValue("APPID_HERE", forHTTPHeaderField: "app_id")
```

## Examples
First user has to register using username and password, as a second factor authentication a photo of user face will be used. It will be choosed from either from Photo Library or shooted directly within app. 

![](https://github.com/mhmmtucan/project1-1/blob/master/docs/gifs/register.gif)

After that, user can login using that username-photo combination

![](https://github.com/mhmmtucan/project1-1/blob/master/docs/gifs/login.gif)

If someone try to login using username-password, it will prompt error.
	
![](https://github.com/mhmmtucan/project1-1/blob/master/docs/gifs/error.gif)

To get maximum benefit from API there is a [guidance](https://www.kairos.com/docs/api/best-practices) for how to take photos in Kairos API docs.

## Version
* 1.0
