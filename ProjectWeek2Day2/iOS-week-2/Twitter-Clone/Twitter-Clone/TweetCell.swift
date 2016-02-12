//
//  TweetCell.swift
//  Twitter-Clone
//
//  Created by Vincent Smithers on 2/11/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var tweetLabel: UILabel!

    @IBOutlet weak var userLabel: UILabel!
    
    var tweet: Tweet! {
        
        didSet {
            self.tweetLabel.text = self.tweet.text
            self.userLabel.text = self.tweet.user?.name
            
            if let user = self.tweet.user {
                if let image = SimpleCache.shared.image((self.tweet.user?.profileImageUrl)!) {
                    self.imgView.image = image
                    return
                }
                
                API.shared.getImage(user.profileImageUrl, completion: { (image) -> () in
                    SimpleCache.shared.setImage(image, key: user.profileImageUrl)
                    self.imgView.image = image
                })
            }
        
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpTweetCell()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpTweetCell() {
        self.imgView.layer.cornerRadius = 10.0
        self.imgView.clipsToBounds = true
        self.preservesSuperviewLayoutMargins = false
        self.contentView.layer.borderWidth = 2.0
        self.separatorInset = UIEdgeInsets(top: 0, left: 5.0, bottom: 0.0, right: 5.0)
        self.layoutMargins = UIEdgeInsetsZero
    }
}
