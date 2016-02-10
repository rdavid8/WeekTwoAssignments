//
//  JSONParser.swift
//  Twitter Clone
//
//  Created by Lacey Vu on 2/8/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

typealias JSONParserCompletion = (success: Bool, tweets: [Tweet]?) -> ()

class JSONParser
{
    class func tweetJSONFrom(data: NSData, completion: JSONParserCompletion)
    {
        NSOperationQueue().addOperationWithBlock { () -> Void in
        
        do {
            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                as? [[String : AnyObject]] {
            
                var tweets = [Tweet]()
                    
                    for tweetJSON in rootObject {
                        
                        guard let tweet = self.tweetFromJSON(tweetJSON) else {return}
                        
                        
                        
                        if let orginal = self.originalTweet(tweetJSON) {
                        
                        tweet.originalTweet = orginal
                        }
                        
                        tweets.append(tweet)
                    }
                    
                    //completion
                    
                    completion (success: true, tweets: tweets)
                    }

            } catch _ {
                completion ( success: false, tweets: nil)
                }
            }
        }
    
    //Mark helper Functions
    
    class func userFromJSON(tweetJSON: [String: AnyObject]) -> User
    {
        guard let name = tweetJSON["screen_name"] as? String else { fatalError("Failed to parse the name. Something is wrong with JSON") }
        guard let profileImageUrl = tweetJSON["profile_image_url"] as? String else { fatalError("Failed to parse the profile image url. Something is wrong") }
        guard let location = tweetJSON["location"] as? String else { fatalError("Failed to parse the location. Something is wrong") }
        
        return User(name: name, profileImageUrl: profileImageUrl, location: location)
    }
    
    class func tweetFromJSON(json: [String: AnyObject]) ->Tweet? {
        guard let text = json["text"] as? String else {return nil}
        guard let id = json["id_str"] as? String else {return nil}
        guard let userJSON = json["user"] as? [String : AnyObject] else{return nil}
        
        return Tweet(text: text, id: id, user: self.userFromJSON(userJSON), originalTweet: nil)
    }
    
    class func originalTweet(tweetJSON: [String: AnyObject]) -> Tweet? {
        guard let retweetObject = tweetJSON["retweeted_status"] as? [String : AnyObject] else { return nil }
        guard let tweet = self.tweetFromJSON(retweetObject) else {fatalError("")}
        return tweet
    }

 }
