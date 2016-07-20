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
        
        deathPic = SKSpriteNode(imageNamed: "Penguin in ice")
        deathPic.position = CGPoint(x: -50, y: 60)
        deathPic.zPosition = 31
        addChild(deathPic)
        
        background = SKSpriteNode(imageNamed: "Game over Background")
        self.addChild(background)
        background.zPosition = 30
        
        percentageCompleteLabel.text = "xx%"
        percentageCompleteLabel.fontSize = 80
        percentageCompleteLabel.fontName = "Comic Sans MS-Bold"
        percentageCompleteLabel.position = CGPoint(x: -50, y: -140)
        percentageCompleteLabel.zPosition = 31
        addChild(percentageCompleteLabel)
        
        let restartButton = MSButtonNode(imageNamed: "Restart Button")
        restartButton.state = .MSButtonNodeStateActive
        restartButton.position.x += 225
        restartButton.zPosition = 31
        addChild(restartButton)
        
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
