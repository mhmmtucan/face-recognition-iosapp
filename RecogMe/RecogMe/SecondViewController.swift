//
//  SecondViewController.swift
//  RecogMe
//
//  Created by Muhammet Uçan on 6.10.2017.
//  Copyright © 2017 Muhammet Uçan. All rights reserved.
//

import UIKit
import Foundation

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var errorPromptField: UILabel!
    let picker = UIImagePickerController()
    var chosenImage:UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.cameraDevice = .front
            picker.modalPresentationStyle = .fullScreen
            picker.showsCameraControls = false
            present(picker,animated: true,completion: {
                self.picker.takePicture()
            })
        }
        else {
            noCamera()
        }
    }
    
    func openPhotoLibrary() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let str64 = imageTobase64(image: chosenImage)
        print(str64)
        
        // make request in order to enrollment of photo
        sendRequest(image: str64, gallery: "MyGallerry", subject: username.text!)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
    
    func imageTobase64(image: UIImage) -> String {
        var base64String = ""
        let  cim = CIImage(image: image)
        if (cim != nil) {
            let imageData = image.highQualityJPEGNSData
            base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        }
        return base64String
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        print(Global.container)
        if let pass = Global.container[username.text!] {
            // user exists check for password
            if password.text! == pass {
                // password matched
                // take a photo of subject
                //openCamera()
                
                let camaraAlert = UIAlertController(title: "Photo?", message: "Take a photo with camera or choose a photo from Photo Library", preferredStyle: UIAlertControllerStyle.alert)
                
                camaraAlert.addAction(UIAlertAction(title: "Camera", style: .cancel, handler: { (action: UIAlertAction!) in
                    self.openCamera()
                }))
                
                camaraAlert.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action: UIAlertAction!) in
                    self.openPhotoLibrary()
                }))
                
                present(camaraAlert, animated: true, completion: nil)
                
                // make request for that face
                // if subject id is the same with username then give pass
                
            }
            else {
                // password is wrong, error prompt
                errorPromptField.text = "Password is invalid"
                errorPromptField.isHidden = false
            }
        }
        else {
            // there is no user with this username, error prompt
            errorPromptField.text = "No username with this"
            errorPromptField.isHidden = false
        }
    }
    
    func sendRequest(image: String, gallery: String, subject: String) {
        /* Configure session, choose between:
         * defaultSessionConfiguration
         * ephemeralSessionConfiguration
         * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        let sessionConfig = URLSessionConfiguration.default
        
        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        /* Create the Request:
         Recognize (POST https://api.kairos.com/recognize)
         */
        
        guard let URL = URL(string: "https://api.kairos.com/recognize") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        
        // Headers
        
        request.addValue("PHPSESSID=o9vg2pbh99sidgj5imfb2krss6", forHTTPHeaderField: "Cookie")
        request.addValue("a5cad8c462c4dca239d717e4b4191455", forHTTPHeaderField: "app_key")
        request.addValue("e00d0538", forHTTPHeaderField: "app_id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // JSON Body
        
        let bodyObject: [String : Any] = [
            "image": image,
            "gallery_name": "MyGallery"
        ]
        request.httpBody = try! JSONSerialization.data(withJSONObject: bodyObject, options: [])
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let responseJSON = responseJSON as? [String:Any] {
                    print("Login data")
                    print(responseJSON)
                    
                    
                    if let images = responseJSON["images"] as? [String:Any] {
                        if let transaction = images["transaction"] as? [String:Any] {
                            if let status = transaction["status"] as? String {
                                if status == "success" {
                                    // face found
                                    // check if subject_name and username matchs
                                    if let subject_id = transaction["subject_id"] as? String {
                                        if subject_id == self.username.text {
                                            // congratz you are in
                                            self.errorPromptField.text = "You are logged in!"
                                            self.errorPromptField.isHidden = false
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}

