//
//  TwitterButton.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class TwitterButton: MSButtonNode {
    init() {
        super.init(imageNamed: "Twitter Button")
        self.state = .MSButtonNodeStateActive
        
        self.selectedHandler = {
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
