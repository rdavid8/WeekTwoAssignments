//
//  DetailViewController.swift
//  Twitter Clone
//
//  Created by Lacey Vu on 2/8/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
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
         self.accountChooser()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupTableView()
    {
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 150
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.blackColor()
        self.tableView.separatorStyle = .SingleLine
        
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
    }
    
    func profileImage(key: String, completion: (image: UIImage)->()) {
        if let image = SimpleCache.shared.image(key) {
            completion(image: image)
            return
        }
        API.shared.getImage(key) { (image) -> () in
            completion(image: image)
        }
    }
    
    func accountChooser() {
        
        API.shared.login { (accounts) -> () in
            
            if let accounts = accounts {
                
                let alertView = UIAlertController(title: "Accounts", message: "", preferredStyle: .ActionSheet)
                
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
    
    func configureCellForIndexPath(indexPath: NSIndexPath) -> TweetCell
    {
        let tweetCell = self.tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell

        let tweet = self.dataSource[indexPath.row]
        
        tweetCell.tweetLabel.text = tweet.text
        self.profileImage((tweet.user?.profileImageUrl)!, completion: { (image) -> () in
            tweetCell.imgView.image = image
        })
     
        if let user = tweet.user{
            tweetCell.userLabel.text = user.name
            tweetCell.userLabel?.textColor = UIColor.redColor()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Fire")
        self.performSegueWithIdentifier(DetailViewController.identifier(), sender: self)
        
    }

}

