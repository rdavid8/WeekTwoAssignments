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
        let serializationQ = dispatch_queue_create("serializationQ", nil)
        dispatch_async(serializationQ) { () -> Void in
            //do your business here...
            
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //call the completion here...
            })
        }
        
        NSOperationQueue().addOperationWithBlock { () -> Void in
        
        do {
            if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                as? [[String : AnyObject]] {
            
                var tweets = [Tweet]()
                
                    for tweetJSON in rootObject {
                        
                        if let
                            text = tweetJSON["text"] as? String,
                            id = tweetJSON["id_str"] as? String,
                            userJSON = tweetJSON["user"] as? [String: AnyObject]{
    
                            let user = self.userFromTweetJSON(userJSON)
                            let tweet = Tweet(text: text, id: id, user: user)
                                
                            
                            tweets.append(tweet)
                        }
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
    
    class func userFromTweetJSON(tweetJSON: [String: AnyObject]) -> User
    {
        guard let name = tweetJSON["name"] as? String else { fatalError("Failed to parse the name. Something is wrong with JSON") }
        guard let profileImageUrl = tweetJSON["profile_image_url"] as? String else { fatalError("Failed to parse the profile image url. Something is wrong") }
        guard let location = tweetJSON["location"] as? String else { fatalError("Failed to parse the location. Something is wrong") }
        
        return User(name: name, profileImageUrl: profileImageUrl, location: location)
    }

    // Mark: first day, load JSON from bundle.
    
    class func JSONData() -> NSData
    {
        guard let tweetJSONPath = NSBundle.mainBundle().URLForResource("tweet", withExtension: "json") else {
            fatalError("Missing tweet.json file") }
        guard let tweetJSONData = NSData(contentsOfURL: tweetJSONPath) else { fatalError("Error creating NSData object.") }
        return tweetJSONData
    }
}
