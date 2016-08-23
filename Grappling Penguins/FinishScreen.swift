//
//  FinishScreen.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

/** This class represents the game over screen that slides down when the player dies */
class FinishScreen: SKNode {
    var distanceTravelledLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    
    override init() {
        super.init()
        
        let background = SKSpriteNode(imageNamed: "GameOver Background")
        self.addChild(background)
        background.zPosition = 30
        
        let cancelButton = CancelButton()
        cancelButton.position = CGPoint(x: -200, y: 75)
        cancelButton.zPosition = 31
        self.addChild(cancelButton)
        
        let facebookButton = FacebookButton()
        facebookButton.position = CGPoint(x: -200, y: 5)
        facebookButton.zPosition = 31
        self.addChild(facebookButton)
        
        let twitterButton = TwitterButton()
        twitterButton.position = CGPoint(x: -200, y: -65)
        twitterButton.zPosition = 31
        self.addChild(twitterButton)
        
        let restartButton = RestartButton()
        restartButton.position.x += 175
        restartButton.zPosition = 31
        self.addChild(restartButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
