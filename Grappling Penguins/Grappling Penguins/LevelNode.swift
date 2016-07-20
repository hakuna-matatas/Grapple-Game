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
    let BACKGROUND_LENGTH: CGFloat = 667
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadLevel() {
        let tutorialScene = SKScene(fileNamed: "Tutorial.sks")!
        let level = tutorialScene.childNodeWithName("tutorialNode")!
        level.removeFromParent()
        self.addChild(level)

        level.enumerateChildNodesWithName("background", usingBlock: {
            node, stop in
            self.levelWidth += self.BACKGROUND_LENGTH
        })
        print(levelWidth)
    }
}