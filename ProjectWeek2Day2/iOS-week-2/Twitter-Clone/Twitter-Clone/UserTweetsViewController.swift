//
//  UserTweetsViewController.swift
//  Twitter-Clone
//
//  Created by Vincent Smithers on 2/11/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class UserTweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource = [Tweet]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tweet: Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserTweets()
        setupTableView()
    }
    
    func setupTableView()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorColor = UIColor.blackColor()
        self.tableView.separatorStyle = .SingleLine
        
        self.tableView.registerNib(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
    }

    func getUserTweets(){
        if let userName = tweet?.user?.name  {
            API.shared.getSelectedUserTweets(userName, completion: { (tweets) -> () in
                if let tweets = tweets {
                    self.dataSource = tweets
                    print("ViewdLoad DataSource: \(self.dataSource.count)")
                    
//                    for tweet in tweets {
////                        print(tweet.user!.name)
////                        print(tweet.text)
//                    }
                    
                }
            })
        }
     
    }
    
}

extension UserTweetsViewController {
    
    func configureCellForIndexPath(indexPath: NSIndexPath) -> TweetCell
    {
        let tweetCell = self.tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
       
        tweet = self.dataSource[indexPath.row]
        
        tweetCell.tweetLabel.text = tweet!.text
        tweetCell.userLabel.text = tweet?.user?.name
        
        return tweetCell
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TableView Datasource: \(dataSource.count)")
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       return configureCellForIndexPath(indexPath)
    }
}
