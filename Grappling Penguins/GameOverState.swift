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
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        scene.physicsWorld.removeAllJoints()
        scene.hero.physicsBody!.velocity.dx = 0
        
        checkForNewHighScore()
        
        self.gameoverOverlay.percentageCompleteLabel.text = scene.distanceTravelledLabel.text
        scene.distanceTravelledLabel.removeFromParent()
        
        if(gameoverOverlay.parent == nil) {
            /* Moves the gameoverOverlay onscreen */
            gameoverOverlay.position.y = 300
            gameoverOverlay.runAction(SKAction.moveToY(50, duration: 0.5))
            scene.camera!.addChild(gameoverOverlay)
        }
    }
    
    func checkForNewHighScore() {
        let FIRRef = FIRDatabase.database().reference()
        let accRef = FIRRef.child("players").child("testAcc")
        
        /* observeSingleEventOfType may be called after scene.distanceTravelled changes
           if the user presses restart too quickly. To prevent the sudden change, save the old value */

        let newScore = scene.distanceTravelled
        
        accRef.child("highScore").observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let highScore = snapshot.value as! Int
            
            if(newScore > highScore) {
                accRef.updateChildValues(["highScore" : newScore])
            }
        })
    }
    
}
