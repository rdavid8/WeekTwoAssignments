//
//  AppDelegate.swift
//  Twitter-Clone
//
//  Created by Lacey Vu on 2/8/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.setUPAppearance()
        return true
    }

    func setUPAppearance() {
    
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
    }
    
}

