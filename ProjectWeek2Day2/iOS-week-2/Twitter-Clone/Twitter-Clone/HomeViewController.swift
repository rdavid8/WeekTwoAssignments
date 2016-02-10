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
    
//    var lazy viewController:
    
    var dataSource = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
         self.accountChooser()
        
       
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupTableView()
    {
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    func accountChooser() {
        
        API.shared.login { (accounts) -> () in
            
            if let accounts = accounts {
                
                let alertView = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
                
                for account in accounts {
                    
                    let action = UIAlertAction(title: account.username, style: UIAlertActionStyle.Default, handler:{(action) in
                        
                        API.shared.account = account
                        
                        self.update()
                        
                        })
                    
                    alertView.addAction(action)
                }
                
                
                
                self.presentViewController(alertView, animated: true, completion: nil)
            }
    }
    }
    
    func update()
    {
        API.shared.GETTweets({ (tweets) -> () in
            if let tweets = tweets {
                self.dataSource = tweets
                }
            })
        
                    
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == ProfileViewController.identifier(){
            guard let profileViewController = segue.destinationViewController as? ProfileViewController else { fatalError("Something is messed up")}
            
            profileViewController.completion = {unowned in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        if segue.identifier == DetailViewController.identifier() {
            guard let detailViewController = segue.destinationViewController as? DetailViewController else {
                fatalError("Something is messed up")
            }
            
            guard let indexPath = self.tableView.indexPathForSelectedRow else {fatalError()}
            
            detailViewController.tweet = self.dataSource[indexPath.row]
            print(detailViewController.tweet?.user)
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
            tweetCell.detailTextLabel?.textColor = UIColor.redColor()
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

