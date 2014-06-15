//
//  postViewController.swift
//  swiftApp
//
//  Created by Klaus on 6/8/14.
//  Copyright (c) 2014 Klaus. All rights reserved.
//

import Foundation
import UIKit


class postViewController: UITableViewController, NSURLConnectionDataDelegate
{
    var posts : NSMutableArray = []
    
    var webData: NSMutableData? = nil

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //
        println("view did load")
        println(baseURL)
        
        var url = NSURL.URLWithString(baseURL + "/post")
        
        var request = NSURLRequest(URL: url)
        
        var connection = NSURLConnection.connectionWithRequest(request,
                                                            delegate: self)
        
        connection.start()
    }
    
}


// MARK: - data source for UITableView
extension postViewController
{
    override func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cellIdentifier = "postCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
            as? UITableViewCell
        
        if cell != nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default,
                reuseIdentifier: cellIdentifier)
        }
        // do something to the cell
        var tempRow = indexPath.row
        if tempRow < posts.count {
            var singleRow = posts[tempRow] as NSDictionary
            println( singleRow["body"] as? String )
            if let rowString = singleRow["body"] as? String {
                cell!.textLabel.text = rowString
            }else{
                cell!.textLabel.text = "Empty"
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!,
        numberOfRowsInSection section: Int) -> Int
    {
        println(posts.count)
        return posts.count
    }
}

extension postViewController
{
    
    func connection(connection: NSURLConnection!,
        didReceiveResponse response: NSURLResponse!)
    {
        println("Get response")
        
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
        
        if let posts = dataDictionary!["posts"] as? NSArray {

            for post : AnyObject in posts {
                self.posts.addObject(post)
                println(post)
            }
        }
        
        if let tview = self.view as? UITableView {
            tview.reloadData()
        }
        webData = nil
    }
    
}