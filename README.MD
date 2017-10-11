# Face Recognition iOS APP Example Using API
This repository provides a working sample of face recognition system which is built to be a second factor 
of a two factor authentication. [Kairos API](https://www.kairos.com/) used for face detection and recognition. By using this sample someone can analyze Kairos API and face recognition function in thier iOS environment. 

# Getting Started

## Prerequisites
Download zip or clone, then directly use.
Developed using Xcode 9.1, iOS 11.1 and Swift 4

## Installing
    In order to use API, App ID and key is needed. This variables have to be provided from Kairos web page. After that have to be inserted in code.
    
    request.addValue("apikeyhere", forHTTPHeaderField: "app_key")
        request.addValue("apii id here", forHTTPHeaderField: "app_id")
