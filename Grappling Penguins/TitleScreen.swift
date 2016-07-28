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
    
    override func didMoveToView(view: SKView) {
        playButton = self.childNodeWithName("playButton") as! MSButtonNode
        
        playButton.selectedHandler = {
            let skView = self.view as SKView!
            let scene = GameScene(fileNamed: "GameScene")
            
            scene?.scaleMode = .AspectFill
            skView.presentScene(scene)
        }
    }
}
