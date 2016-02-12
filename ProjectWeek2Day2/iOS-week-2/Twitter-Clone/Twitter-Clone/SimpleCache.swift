//
//  SimpleCache.swift
//  Twitter-Clone
//
//  Created by Vincent Smithers on 2/11/16.
//  Copyright © 2016 Lacey Vu. All rights reserved.
//

import UIKit

class SimpleCache {
    
    static let shared = SimpleCache()
    private init() {}
    
    private var cache = [String : UIImage]()
    private let capacity = 20 //Keep 20 recent images
    
    func image(key: String) -> UIImage? {
       return self.cache[key]
    }
    
    func setImage(image: UIImage, key: String) {
        
        if self.cache.count >= capacity {
            guard let key = Array(self.cache.keys).last else {return} //Don't Understand
            self.cache[key] = nil
        }
        
        //set image for key
        self.cache[key] = image
    }
}
