//
//  Api.swift
//  Twitter-Clone
//
//  Created by Lacey Vu on 2/9/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import Foundation
import Accounts
import Social

class API
{
    static let shared = API()
    private init() {}
    
    var account: ACAccount?
    
    func GETTweets(completion: (tweets: [Tweet]?) -> ())
    {
        if let _ = self.account
        {
            self.updateTimeline(completion)
        } else {
            self.login ({ (account) -> () in
                if let account = self.account {
                    
                    API.shared.account = account
                    
                    //Make the tweets call
                    self.updateTimeline(completion)
                } else { print("Account is nil.") }
                
            })
        }
    }
    
    //
    
    private func updateTimeline(completion: (tweets: [Tweet]?) -> ())
    {
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json"), parameters: nil)
        
        request.account = self.account
        request.performRequestWithHandler { (data, response, error) -> Void in
            
            if let _ = error {
                print("ERROR: SLRequesttyoe .GET could not be completed")
                NSOperationQueue.mainQueue().addOperationWithBlock { completion( tweets: nil) } ; return
                    completion(tweets: nil)
            }
            
            switch response.statusCode {
            case 200...299:
                
                JSONParser.tweetJSONFrom(data, completion: { (success, tweets) -> () in
                    NSOperationQueue.mainQueue().addOperationWithBlock ({ completion(tweets: tweets) })
                    
                    
                })
            case 400...500:
                print("Bad Request")
            case 500...600:
                print("Server Error")
            default: break
            }
        }
    }
    
    func login(completion: (accounts: [ACAccount]?) -> ())
    {
        //creaate account store
        
        let accountStore = ACAccountStore()
        
        //create account type
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted, error) -> Void in
            if let _ = error {
                print("Error: request access to acounts")
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(accounts: nil)
                })
            }
            
            if granted {
                
                if let accounts = accountStore.accountsWithAccountType(accountType) as? [ACAccount] {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completion(accounts: accounts)
                        print("granted")
                        
                    })
                    
                }
            }
            
            
        }
        
        
        
        
        
    }
    
    
}

   
        
        
        


    
