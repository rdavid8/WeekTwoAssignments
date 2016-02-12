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
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var retweetLabel: UILabel!
    
    var tweet: Tweet?
    
    class func identifier() -> String {
        return "Push"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImage()
        setUpDetailController()
    }
    
    func setUpDetailController() {
        
        self.navigationItem.title = tweet?.user?.name
        
        userLabel.text = tweet?.user?.name
        
        if tweet?.originalTweet == nil {
            //original tweet
            if let user = tweet?.user {
                profileImage(user.profileImageUrl, completion: { (image) -> () in
                    self.imageDetail.image = image
                })
            }
            
            tweetLabel.text = tweet?.text
            retweetLabel.layer.opacity = 0
            
            self.navigationController?.title = tweet?.user?.name
            
        }else {
            
            //Retweet
            if let user = tweet?.user {
                retweetLabel.text = "RETWEET BY \(user.name)"
            }
            
            tweetLabel.text = tweet?.originalTweet?.text
            userLabel.hidden = true
             self.navigationItem.title = "ReTweet"
        
        }
        
        if let tweet = self.tweet {
            print(tweet.text)
        }
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
    
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushUserTweets" {
            guard let destVc = segue.destinationViewController as? UserTweetsViewController else {fatalError("segueIssues")}
            destVc.tweet = self.tweet
        }
    }
    
    
    func setUpImage() {
        imageDetail.layer.cornerRadius = 25.0
        imageDetail.userInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: "imageTapped:")
        self.imageDetail.addGestureRecognizer(gesture)
    }
    
    func imageTapped(sender: UIImageView){
       
        self.performSegueWithIdentifier("PushUserTweets", sender: self)
    }


}