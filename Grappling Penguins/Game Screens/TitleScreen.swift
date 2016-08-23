//
//  TitleScreen.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/19/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class TitleScreen: SKScene {
    var playButton: MSButtonNode!
    var waterScrollNode: SKNode!
    var water1: SKSpriteNode!
    var water2: SKSpriteNode!
    let waterScrollSpeed = CGFloat(3)
    
    override func didMoveToView(view: SKView) {
        /* For Debugging Purposes NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!) */
        
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        water1 = self.childNodeWithName("//water1") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        waterScrollNode = self.childNodeWithName("waterScrollNode")
        
        playButton.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene")
            
            scene?.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        scrollWater()
    }
    
    func scrollWater() {
        waterScrollNode.position.x -= waterScrollSpeed
        
        for water in waterScrollNode.children as! [SKSpriteNode] {
            let waterPosition = waterScrollNode.convertPoint(water.position, toNode: self)
            
            if(waterPosition.x <= -self.frame.width/2) {
                /* In the case that waterPosition.x < -self.frame.width/2, there will be a slight
                 gap between the two water sprites. difference accounts for this gap */
                let difference = waterPosition.x - (-water.size.width)
                let newPosition = CGPoint(x: water.size.width + difference, y: waterPosition.y)
                water.position = self.convertPoint(newPosition, toNode: waterScrollNode)
            }
        }
    }
}
