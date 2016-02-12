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
            self.updateTimeline("https://api.twitter.com/1.1/statuses/home_timeline.json", completion: completion)
        } else {
            self.login ({ (account) -> () in
                if let account = self.account {
                    
                    API.shared.account = account
                    
                    //Make the tweets call
                    self.updateTimeline("https://api.twitter.com/1.1/statuses/home_timeline.json", completion: completion)
                } else { print("Account is nil.") }
                
            })
        }
    }
    
    func getSelectedUserTweets(userName: String, completion: (tweets: [Tweet]?)->()) {
        self.updateTimeline("https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=\(userName)", completion: completion)
    }


    func getImage(urlString: String, completion: (image: UIImage)->()){
        
        let queue = NSOperationQueue()
        queue.addOperationWithBlock{() -> Void in
            
            guard let url = NSURL(string: urlString) else{return}
            guard let data = NSData(contentsOfURL: url) else {return}
            guard let image = UIImage(data: data) else {return}
            
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion(image: image)
            })
        }
    }
    
    private func updateTimeline(url: String, completion: (tweets: [Tweet]?) -> ())
    {
        let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: NSURL(string: url), parameters: nil)
        
        request.account = self.account
        request.performRequestWithHandler { (data, response, error) -> Void in
            
            if let _ = error {
                print("ERROR: SLRequesttyoe .GET could not be completed\(url)")
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
        let accountStore = ACAccountStore()
       
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
    
    func getUserData(completion:(user: User?)->()) {
        
    let url = "https://api.twitter.com/1.1/account/verify_credentials.json"
        
       let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: NSURL(string: url), parameters: nil)
        
       request.account = self.account
        
        request.performRequestWithHandler { (data, response, error) -> Void in
            
            if let _ = error {
                print("Error SLRequest type get return status code")
                NSOperationQueue.mainQueue().addOperationWithBlock{completion(user: nil)}; return
            }
            
            switch response.statusCode {
            case 200...299:
             
                do{
                    if let rootObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String : AnyObject] {
                        
                        let user = JSONParser.userFromJSON(rootObject)
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            completion(user: user)
                        })
                       
                    }
                }catch{
                    print("ERROR")
                }
                
                default:
                    break
            }
        }
    }
    
}

   
        
        
        


    
