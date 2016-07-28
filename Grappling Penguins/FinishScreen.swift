//
//  FinishScreen.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

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
        
        distanceTravelledLabel.fontSize = 30
        distanceTravelledLabel.fontName = "Agent Orange"
        distanceTravelledLabel.position = CGPoint(x: -20, y: 5)
        distanceTravelledLabel.zPosition = 31
        self.addChild(distanceTravelledLabel)
        
        highScoreLabel.fontSize = 15
        highScoreLabel.fontName = "Agent Orange"
        highScoreLabel.position = CGPoint(x: -20, y: -25)
        highScoreLabel.zPosition = 31
        self.addChild(highScoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
