//
//  GameOverScreen.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/19/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit


/* 
   This class contains all the elements of the game over screen in a SKNode.
   The class is instantiated in GameOverState.swift.
 
   NOTE: The reason this class subclasses SKNode and not SKScene is because
         the scene will overlay GameScene, rather than replace it entirely. 
 */
class GameOverScreen: SKNode {
    /* All the UI elements of the game over screen */
    var restartButton: MSButtonNode!
    var background: SKSpriteNode!
    var deathPic: SKSpriteNode!
    var percentageCompleteLabel = SKLabelNode()
    
    override init() {
        super.init()
        
        background = SKSpriteNode(imageNamed: "GameOver Background")
        self.addChild(background)
        background.zPosition = 30
        
        percentageCompleteLabel.text = "100%"
        percentageCompleteLabel.fontSize = 80
        percentageCompleteLabel.fontName = "Agent Orange-Bold"
        percentageCompleteLabel.position = CGPoint(x: -50, y: -70)
        percentageCompleteLabel.zPosition = 31
        self.addChild(percentageCompleteLabel)
        
        let restartButton = MSButtonNode(imageNamed: "Restart Button")
        restartButton.state = .MSButtonNodeStateActive
        restartButton.position.x += 175
        restartButton.zPosition = 31
        self.addChild(restartButton)
        
        restartButton.selectedHandler = {
            if let newGameScene = GameScene(fileNamed: "GameScene") {
                /* Parent is camera. Camera's parent is GameScene */
                let parent = self.parent?.parent as! GameScene
                let skView = parent.view as SKView!
                
                newGameScene.scaleMode = .AspectFill
                skView.presentScene(newGameScene)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
