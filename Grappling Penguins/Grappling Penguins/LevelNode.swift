//
//  LevelNode.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/18/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation
import SpriteKit

class LevelNode: SKNode {
    
    var levelWidth:CGFloat = 0
    
    override init() {
        super.init()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadLevel() {
        let path = NSBundle.mainBundle().pathForResource("Tutorial", ofType: "sks")!
        let newLevel = SKReferenceNode(URL: NSURL(fileURLWithPath: path))
        self.addChild(newLevel)

        newLevel.enumerateChildNodesWithName("background", usingBlock: {
            node, stop in
            
            print(node)
            self.levelWidth += 667
        })
        
        for child in newLevel.children {
            print(child.position)
        }
        print(levelWidth)
    }
    
}