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
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.physicsWorld.removeAllJoints()
        scene.hero.physicsBody!.velocity.dx = 0
        
        checkForNewHighScore()
        
                self.gameoverOverlay.distanceTravelledLabel.text = "Distance: \(scene.distanceTravelledLabel.text!)"
        scene.distanceTravelledLabel.removeFromParent()
        
        if(gameoverOverlay.parent == nil) {
            /* Moves the gameoverOverlay onscreen */
            gameoverOverlay.position.y = 300
            gameoverOverlay.runAction(SKAction.moveToY(50, duration: 0.5))
            scene.camera!.addChild(gameoverOverlay)
        }
    }
    
    func checkForNewHighScore() {
        let newScore = scene.distanceTravelled
        
        /* Local Highscore Update */
        if(newScore > scene.highScore) {
            self.userDefaults.setValue(scene.distanceTravelled, forKey: "HighScore")
            self.gameoverOverlay.highScoreLabel.text = "CONGRATS BABE <3"
        }
        else {
            self.gameoverOverlay.highScoreLabel.text = "Highscore: \(String(scene.highScore))"
        }
        
        /* Firebase Highscore Update */
        let FIRRef = FIRDatabase.database().reference()
        let accRef = FIRRef.child("players").child("testAcc")
        
        accRef.child("highScore").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let highScore = snapshot.value as! Int
            
            if(newScore > highScore) {
                accRef.updateChildValues(["highScore" : newScore])
            }
        })
    }
    
}
