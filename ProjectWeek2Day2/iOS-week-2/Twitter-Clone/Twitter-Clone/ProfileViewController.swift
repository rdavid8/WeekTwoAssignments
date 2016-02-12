//
//  ProfileViewController.swift
//  Twitter-Clone
//
//  Created by Vincent Smithers on 2/10/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

typealias ProfileViewControllerCompletion = () -> ()

class ProfileViewController: UIViewController, Identity {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    var completion: ProfileViewControllerCompletion?
    
    class func identifier() -> String {
        return "ShowProfile"
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
    }
    
    
    func setUpLabels() {
       
        API.shared.getUserData { (user) -> () in
            
            self.image.userInteractionEnabled = true
            
            if let userName = user?.name {
            self.userName.text = userName
                print(user?.profileImageUrl)
            }
            if let location = user?.location {
                self.location.text = location
            }
            
        }
            
    }
    
       @IBAction func dismissButtonClicked(sender: AnyObject) {
        guard let completion = self.completion else {return}
        completion()
    }
    
    
}
