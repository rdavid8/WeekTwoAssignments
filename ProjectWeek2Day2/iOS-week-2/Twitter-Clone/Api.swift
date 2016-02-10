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
        
        //
        
        
        // completion(accounts: accountStore.accountsWithAccountType(accountType))
    }

    
//    private func login(completion: (account: ACAccount?) -> ())
//    {
//        let accountStore = ACAccountStore()
//        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
//        
//        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { ( granted, error) -> Void in
//            if let _ = error {
//                print("ERROR: Request access to accounts return an error")
//                
//                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                completion(account: nil)
//                })
//            }
//            
//            if granted {
//                
//                let accounts = accountStore.accountsWithAccountType(accountType)
//                for account in accounts {
//                    print(account)
//                }
//                if let account = accountStore.accountsWithAccountType(accountType).first as? ACAccount{
//                    NSOperationQueue.mainQueue().addOperationWithBlock { completion(account: account) }
//                    return
//                }
//                
//                print("ERROR: No twitter accounts were found on this device")
//                NSOperationQueue.mainQueue().addOperationWithBlock { completion(account: nil) }
//                 return
//            }
//            
//            print("ERROR: This app requires access to Twitter Accounts.")
//            NSOperationQueue.mainQueue().addOperationWithBlock { completion(account: nil) }
//            return
//            
//        }
//    }
//
func GETOAuthUser(completion: (user: User?) -> ())
{
    let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json"), parameters: nil)
    
    request.account = self.account
    request.performRequestWithHandler { (data, response, error) -> Void in
        
        if let _ = error {
        NSOperationQueue.mainQueue().addOperationWithBlock{ completion(user: nil) }
        return
        }
        
        switch response.statusCode {
        case 200...299:
            
            do {
                if let userJSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject] {
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock( { () -> Void in
                        completion(user: JSONParser.userFromTweetJSON(userJSON))
                })
                }
            } catch _ {}
    
                default: break
         
            }
        }
    
    }
}