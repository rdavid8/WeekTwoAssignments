//
//  DetailViewController.swift
//  Twitter Clone
//
//  Created by Lacey Vu on 2/8/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
    }
    
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.update()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView()
    {
        self.tableView.dataSource = self
    }
    
    func update()
    {
        
        API.shared.login { (accounts) -> () in
            if let accounts = accounts {
                
                let alertView = UIAlertController()
                
                for account in accounts {
                    let action = UIAlertAction(title: account.username, style: UIAlertActionStyle.Default, handler:{(action) in
                      
                        API.shared.account = account
                        
                        API.shared.GETTweets({ (tweets) -> () in
                            if let tweets = tweets {
                            self.dataSource = tweets
                            }
                        })
                    })
                    
                alertView.addAction(action)

                

            }
                
            self.presentViewController(alertView, animated: true, completion: nil)
    }
        
    }


    func popAlertView(s1: String, s2: String) {
    
        let alertView = UIAlertController()
    
        let action = UIAlertAction(title: "", style: UIAlertActionStyle.Default) { (action) -> Void in
            print("Test")
        }
    
        alertView.addAction(action)
    
        self.presentViewController(alertView, animated: true, completion: nil)
    
    }
    }
}


extension HomeViewController
{
    
    func configureCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell
    {
        let tweetCell = self.tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath)
        let tweet = self.dataSource[indexPath.row]
        tweetCell.textLabel?.text = tweet.text
        
        
        if let user = tweet.user{
            tweetCell.detailTextLabel?.text = user.name
        }
        
        return tweetCell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        return self.configureCellForIndexPath(indexPath)
    }
}

