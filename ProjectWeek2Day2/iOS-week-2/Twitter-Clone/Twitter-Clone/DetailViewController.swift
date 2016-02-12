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
        setUpView()
    }
    
    func setUpView() {
        self.view.layer.borderWidth = 4.0
        self.view.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func setUpDetailController() {
        if let userName = tweet?.user?.name {
            self.navigationItem.title = userName
            userLabel.text = userName
        }
        //original tweet
        if tweet?.originalTweet == nil {
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
            if let user = tweet?.originalTweet?.user {
                retweetLabel.text = "RETWEET BY \(user.name)"
                profileImage(user.profileImageUrl, completion: { (image) -> () in
                    self.imageDetail.image = image
                })
            }
            
            if let orginalTweetText = tweet?.originalTweet?.text {
                tweetLabel.text = orginalTweetText
                userLabel.hidden = true
                self.navigationItem.title = "ReTweet"
            }
            
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
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PushUserTweets" {
            
            guard let destVc = segue.destinationViewController as? UserTweetsViewController else {fatalError("segueIssues")}
            
            if self.tweet?.originalTweet == nil {
            destVc.tweet = self.tweet
            }else {
                destVc.tweet = self.tweet?.originalTweet
            }
        }
    }
    
    //MARK: Image Setup
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