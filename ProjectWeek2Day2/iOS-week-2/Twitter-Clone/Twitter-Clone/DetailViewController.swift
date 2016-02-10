//
//  DetailViewController.swift
//  Twitter-Clone
//
//  Created by Vincent Smithers on 2/10/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tweetLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    var tweet: Tweet?
    
    class func identifier() -> String {
        return "Push"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDetailController()
    }
    
    func setUpDetailController() {
        
        self.navigationItem.title = tweet?.user?.name
        
        userLabel.text = tweet?.user?.name
        
        if tweet?.originalTweet == nil {
            tweetLabel.text = tweet?.text
            retweetLabel.layer.opacity = 0
            self.navigationController?.title = tweet?.user?.name
            
        }else {
            tweetLabel.text = tweet?.originalTweet?.text
             self.navigationItem.title = "ReTweet"
        }
        
        if let tweet = self.tweet {
            print(tweet.text)
        }
    }

}