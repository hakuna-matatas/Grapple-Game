//
//  FinishScreen.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/22/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class FinishScreen: SKNode {
    
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
    }
    
    func makeWinScreen() {
        let nextLevelButton = MSButtonNode(imageNamed: "Next Button")
        nextLevelButton.state = .MSButtonNodeStateActive
        nextLevelButton.position.x += 175
        nextLevelButton.zPosition = 31
        self.addChild(nextLevelButton)
        
        let congratsLabel = SKSpriteNode(imageNamed: "Congrats Babe")
        congratsLabel.position.x = -25
        congratsLabel.zPosition = 31
        self.addChild(congratsLabel)
    }
    
    func makeLoseScreen() {
        let restartButton = RestartButton()
        restartButton.position.x += 175
        restartButton.zPosition = 31
        self.addChild(restartButton)
        
        let percentageCompleteLabel = SKLabelNode()
        percentageCompleteLabel.text = "32%"
        percentageCompleteLabel.fontSize = 80
        percentageCompleteLabel.fontName = "Agent Orange-Bold"
        percentageCompleteLabel.position.x = -50
        percentageCompleteLabel.zPosition = 31
        self.addChild(percentageCompleteLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
