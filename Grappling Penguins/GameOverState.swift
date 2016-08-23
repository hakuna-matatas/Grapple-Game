//
//  GameOverState.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/18/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import GameplayKit
import SpriteKit
import FirebaseDatabase

class GameOverState: GKState {
    unowned let scene: GameScene
    let gameoverOverlay = FinishScreen()
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var highScoreNode = SKNode()
    var highScore = 0 {
        didSet {
            highScoreNode.removeAllChildren()
            
            let highScoreSprite = SKSpriteNode(imageNamed: "High Score")
            highScoreSprite.anchorPoint.x = 0
            highScoreNode.addChild(highScoreSprite)
            
            let spaceFromFirstNum = highScoreSprite.size.width + 5
            Numbers.createNumberSprite(&highScoreNode, score: highScore, isMainScore: false, spaceFromFirstNum: spaceFromFirstNum)
        }
    }
    
    init(scene: GameScene) {
        self.scene = scene
        
        /* Loading high score from previous sessions (if it exists) */
        if let previousHighScore = userDefaults.valueForKey("HighScore") {
            self.highScore = previousHighScore as! Int
        }
        
        /* Generates a high score sprite label */
        if(highScore != 0) {
            let highScoreSprite = SKSpriteNode(imageNamed: "High Score")
            highScoreSprite.anchorPoint.x = 0
            highScoreNode.addChild(highScoreSprite)
            
            let spaceFromFirstNum = highScoreSprite.size.width + 5
            Numbers.createNumberSprite(&highScoreNode, score: highScore, isMainScore: false, spaceFromFirstNum: spaceFromFirstNum)
        }
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        let playingState = previousState as! PlayingState
        let distanceTravelled = playingState.distanceTravelled
        let playingStateScoreNode = playingState.scoreNode
        
        scene.hero.removeFromParent()
        scene.grapplingHook.removeFromParent()

        checkForNewHighScore(distanceTravelled)

        var scoreNode = SKNode()
        
        Numbers.createNumberSprite(&scoreNode, score: distanceTravelled, isMainScore: true, spaceFromFirstNum: 0)
        
        self.gameoverOverlay.addChild(scoreNode)
        scoreNode.zPosition = 31
        scoreNode.position.y += 15
        
        playingStateScoreNode.removeFromParent()
        
        if(gameoverOverlay.parent == nil) {
            /* Moves the gameoverOverlay onscreen */
            gameoverOverlay.position.y = 300
            gameoverOverlay.runAction(SKAction.moveToY(50, duration: 0.5))
            scene.camera!.addChild(gameoverOverlay)
        }
    }
    
    func checkForNewHighScore(distanceTravelled: Int) {
        let newScore = distanceTravelled
        
        /* Local Highscore Update */
        if(newScore > self.highScore) {
            highScore = newScore
            self.highScoreNode.removeFromParent()
            self.userDefaults.setValue(distanceTravelled, forKey: "HighScore")
            
            let CONGRATS_MESSAGE = SKSpriteNode(imageNamed: "Congrats Babe")
            self.gameoverOverlay.addChild(CONGRATS_MESSAGE)
            CONGRATS_MESSAGE.zPosition = 31
            CONGRATS_MESSAGE.position.y -= 15
            pulseColor(CONGRATS_MESSAGE)
        }
        else {
            self.gameoverOverlay.addChild(highScoreNode)
            highScoreNode.zPosition = 31
            highScoreNode.position.y -= 15
            highScoreNode.position.x -= 85
        }
    }
    
    func pulseColor(sprite: SKSpriteNode) {
        let pulseCyan = SKAction.sequence([
                SKAction.colorizeWithColor(UIColor.cyanColor(), colorBlendFactor: 1.0, duration: 0.2),
                SKAction.waitForDuration(0.1),
                SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.2)])
        
        sprite.runAction(SKAction.repeatActionForever(pulseCyan))
    }
    
}


