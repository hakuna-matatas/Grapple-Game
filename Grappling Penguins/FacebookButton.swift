//
//  FacebookButton.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit
import FBSDKShareKit
import FBSDKCoreKit
import Social

class FacebookButton: MSButtonNode {
    init() {
        super.init(imageNamed: "Facebook Button")
        self.state = .MSButtonNodeStateActive

        self.selectedHandler = {
            NSNotificationCenter.defaultCenter().postNotificationName("showFBSheet", object: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
