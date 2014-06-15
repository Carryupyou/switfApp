//
//  ViewController.swift
//  swiftApp
//
//  Created by Klaus on 6/4/14.
//  Copyright (c) 2014 Klaus. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var webData : NSMutableData? = nil
    var uid = -1
    
    @IBOutlet var usernameInput : UITextField
    @IBOutlet var passwordInput : UITextField
    
    @IBAction func backgroundTap(sender : AnyObject) {
        usernameInput.resignFirstResponder()
        passwordInput.resignFirstResponder()
    }
    @IBAction func passwordDoneEditing(sender : UITextField) {
        sender.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        uid = -1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func jumpButton(sender : AnyObject) {
        //check userName and password first
        var username = usernameInput.text
        var password = passwordInput.text
        if username == "" || password == "" {
            var alert = UIAlertController(
                title: "Alert",
                message: "The username or password cannot be empty",
                preferredStyle:
                UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        
        } else {
            //Try to use the username and password to log in
            var url = NSURL.URLWithString(baseURL + "/user/login")
            var request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "POST"
            
            var dataDict = ["Username":username, "Password":password]

            var dataArray: NSMutableArray = ["Username=" + username as String,
                             "Password=" + password as String]
            var dataString = dataArray.componentsJoinedByString("&")
            var bodyData = dataString.dataUsingEncoding(NSUTF8StringEncoding,
                allowLossyConversion: true)
            var jsonResult = NSJSONSerialization.dataWithJSONObject(dataDict, options: NSJSONWritingOptions.PrettyPrinted, error: nil)

//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var testString: NSString = "abc"
//            request.HTTPBody = testString.dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = bodyData
            
            var connection = NSURLConnection.connectionWithRequest(
                request,
                delegate: self)

            connection.start()
            
        }
        
    }


}

extension ViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        if usernameInput.isFirstResponder() {
            passwordInput.becomeFirstResponder()
            return false
        }
        return true
    }
}

extension ViewController: NSURLConnectionDataDelegate
{
    func connection(connection: NSURLConnection!,
        didReceiveResponse response: NSURLResponse!)
    {
        println("Get response")
        println(response)
        
        if webData == nil {
            webData = NSMutableData()
        }
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!)
    {
        webData!.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var output = NSString(data: webData!, encoding: NSUTF8StringEncoding)
        
        //        println(output)
        
        
        var dataDictionary = NSJSONSerialization.JSONObjectWithData(webData,
            options: NSJSONReadingOptions.MutableLeaves,
            error: nil) as? NSDictionary
        
        println(dataDictionary)
        
        if dataDictionary {
            if dataDictionary!["success"] as NSObject == 1 {
                uid = dataDictionary!["uid"] as NSInteger
                self.performSegueWithIdentifier("logIn", sender: self)
            }
        }
        
        webData = nil
    }
}
