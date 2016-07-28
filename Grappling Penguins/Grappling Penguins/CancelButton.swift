//
//  CancelButton.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class CancelButton: MSButtonNode {
    init() {
        super.init(imageNamed: "Cancel Button")
        self.state = .MSButtonNodeStateActive
        
        self.selectedHandler = {
            if let titleScreen = TitleScreen(fileNamed: "TitleScreen") {
                let gameScene = self.parent?.parent?.parent as! GameScene
                let skView = gameScene.view as SKView!
                
                titleScreen.scaleMode = .AspectFill
                skView.presentScene(titleScreen)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
