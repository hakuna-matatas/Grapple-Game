//
//  RestartButton.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class RestartButton: MSButtonNode {
    init() {
        super.init(imageNamed: "Restart Button")
        self.state = .MSButtonNodeStateActive
    
        self.selectedHandler = {
            if let newGameScene = GameScene(fileNamed: "GameScene") {
                /* 1st parent is game over screen. 2nd Parent is camera. 
                   Camera's parent is GameScene */
                let gameScene = self.parent?.parent?.parent as! GameScene
                let skView = gameScene.view as SKView!
                
                newGameScene.scaleMode = .AspectFill
                skView.presentScene(newGameScene)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}