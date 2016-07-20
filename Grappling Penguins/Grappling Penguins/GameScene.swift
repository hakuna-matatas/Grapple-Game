//
//  GameScene.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 6/30/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameState: GKStateMachine!
    var readyState: GKState!
    var playingState: GKState!
    var gameOverState: GKState!
    var winState: GKState!
    
    var lastUpdateTime: CFTimeInterval = 0
    
    /* Declaring variables */
    var ground: SKSpriteNode!
    var water1: SKSpriteNode!
    var water2: SKSpriteNode!
    var ceiling1: SKSpriteNode!
    var background1: SKSpriteNode!
    
    var levelNode = LevelNode()

    var hero: Hero!
    var grapplingHook: GrapplingHook!
    
    var waterScrollNode: SKNode!
    let waterScrollSpeed: CGFloat = 5.0
    
    let NORMAL_TEXTURE = SKTexture(imageNamed: "Stationary-1")
    let FLYING_TEXTURE = SKTexture(imageNamed: "Flying-1")
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7)
        hero.setupPhysics()
        
        physicsWorld.contactDelegate = self
        
        levelNode.loadLevel()
        
        readyState = ReadyState(scene: self)
        playingState = PlayingState(scene: self)
        gameOverState = GameOverState(scene: self)
        winState = WinState(scene: self)
        
        gameState = GKStateMachine(states: [readyState, playingState, gameOverState, winState])
        gameState.enterState(ReadyState)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hero.texture = NORMAL_TEXTURE
        
        for touch in touches {
            let location = touch.locationInNode(camera!)
            let X_COOR_HALF_SCREEN = camera!.frame.size.width / 2
            
            if(location.x >= X_COOR_HALF_SCREEN) {
                grapplingHook = GrapplingHook(heroPosition: hero.position)
                self.addChild(grapplingHook!)
                
                grapplingHook!.shootGrapplingHook()
                
                /* Ensures grapplingHook always released at ~45 degree angle from hero */
                grapplingHook!.physicsBody!.velocity.dx += hero.physicsBody!.velocity.dx
                grapplingHook!.physicsBody!.velocity.dy += hero.physicsBody!.velocity.dy
            }
            else {
                //Left side of screen
                hero.jump()
            }
        }
        
        if(gameState.currentState == readyState) {
            gameState.enterState(PlayingState)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        scrollWater()
        
        if(hero.position.y < 0) { gameState.enterState(GameOverState) }
        
        let timePassed = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameState.updateWithDeltaTime(timePassed)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(gameState.currentState == gameOverState) { return }
        
        hero.texture = FLYING_TEXTURE
        
        /* Don't release grappling hook if jump button is pressed */
        if let _ = grapplingHook {
            for touch in touches {
                let location = touch.locationInNode(camera!)
                let X_COOR_HALF_SCREEN = camera!.frame.size.width / 2
                
                if(location.x >= X_COOR_HALF_SCREEN) {
                    grapplingHook.removeFromParent()
                    boostXVelocity()
                }
            }
        }
    }
    
    var grapplingHookMadeContact = false
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if(nodeA!.name == "GrapplingHook" || nodeB!.name == "GrapplingHook") {
            grapplingHookMadeContact = true
        }
        else if(nodeA!.physicsBody?.categoryBitMask == PhysicsCategory.Goal ||
                nodeB!.physicsBody?.categoryBitMask == PhysicsCategory.Goal) {
            gameState.enterState(WinState)
        }
    
    }
    
    override func didSimulatePhysics() {
        if grapplingHook == nil { return }
        
        if(grapplingHookMadeContact) {
            grapplingHook.physicsBody?.dynamic = false
            
            let positionPlaceholder = hero.position
            hero.position = grapplingHook.position
            
            let springJoint = SKPhysicsJointSpring.jointWithBodyA(
                grapplingHook.physicsBody!,
                bodyB: hero.physicsBody!,
                anchorA: hero.position,
                anchorB: grapplingHook.position)
            
            springJoint.damping = 4
            springJoint.frequency = 1
            physicsWorld.addJoint(springJoint)
            hero.position = positionPlaceholder
            grapplingHookMadeContact = false
            
            grapplingHook.fillColor = UIColor.blueColor()
        }
    }
    
    func boostXVelocity() {
        hero.physicsBody!.applyImpulse(CGVector(dx: 5, dy: 0))
    }
    
    func scrollWater() {
        waterScrollNode.position.x -= waterScrollSpeed
        
        for water in waterScrollNode.children as! [SKSpriteNode] {
            let waterPosition = waterScrollNode.convertPoint(water.position, toNode: camera!)
            
            if(waterPosition.x <= -water.size.width) {
                let newPosition = CGPoint(x: water.size.width,
                                          y: waterPosition.y)
                water.position = camera!.convertPoint(newPosition, toNode: waterScrollNode)
            }
        }
    }
    
    func initializeVars() {
        ground = self.childNodeWithName("ground") as! SKSpriteNode
        water1 = self.childNodeWithName("//water1") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        ceiling1 = self.childNodeWithName("ceiling1") as! SKSpriteNode
        background1 = self.childNodeWithName("background1") as! SKSpriteNode
        waterScrollNode = self.childNodeWithName("waterScrollNode")
        hero = self.childNodeWithName("hero") as! Hero
        self.addChild(levelNode)
        
        ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        ceiling1.physicsBody?.categoryBitMask = PhysicsCategory.Ceiling
        ceiling1.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ceiling1.physicsBody?.contactTestBitMask = PhysicsCategory.GrapplingHook
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}
