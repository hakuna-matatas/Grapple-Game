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
    /* Game States */
    var gameState: GKStateMachine!
    var readyState: GKState!
    var playingState: GKState!
    var gameOverState: GKState!
    var winState: GKState!
    
    /* GKStates have update functions, but require a NSTimeInterval
       as a parameter. We subtract lastUpdateTime from currentTime (found 
       in the update method), thus finding the time between update calls */
    var lastUpdateTime: CFTimeInterval = 0
    
    /* Each level has the same start area. These
       sprite nodes make up this start area. */
    var ground: SKSpriteNode!
    var water1: SKSpriteNode!
    var water2: SKSpriteNode!
    var ceiling1: SKSpriteNode!
    var background1: SKSpriteNode!
    
    /* Each level is loaded into the level node. See class for more details */
    var levelNode = LevelNode()

    var hero: Hero!
    var grapplingHook: GrapplingHook!
    var grapplingHookMadeContact = false
    
    /* Used to scroll the water across the world */
    var waterScrollNode: SKNode!
    let waterScrollSpeed: CGFloat = 5.0
    
    let STATIONARY_TEXTURE = SKTexture(imageNamed: "Stationary-1")
    let FLYING_TEXTURE = SKTexture(imageNamed: "Flying-1")
    
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        setupPhysics()
        
        levelNode.loadLevel()
        
        readyState = ReadyState(scene: self)
        playingState = PlayingState(scene: self)
        gameOverState = GameOverState(scene: self)
        winState = WinState(scene: self)
        
        gameState = GKStateMachine(states: [readyState, playingState, gameOverState, winState])
        gameState.enterState(ReadyState)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(gameState.currentState == gameOverState) { return }
        
        hero.texture = STATIONARY_TEXTURE
        
        for touch in touches {
            let location = touch.locationInNode(camera!)
            let X_COOR_HALF_SCREEN = camera!.frame.size.width / 2
            
            /* Right side of screen tapped */
            if(location.x >= X_COOR_HALF_SCREEN) {
                /* Initializes grappling hook and shoots it */
                grapplingHook = GrapplingHook(heroPosition: hero.position)
                self.addChild(grapplingHook)
                grapplingHook.shootGrapplingHook()
            }
            /* Left side of screen tapped */
            else {
                hero.jump()
            }
        }
        
        /* Game starts when player taps the screen */
        if(gameState.currentState == readyState) {
            gameState.enterState(PlayingState)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hero.texture = FLYING_TEXTURE
        
        /* Determining if left or right side of screen was tapped */
        if let _ = grapplingHook {
            for touch in touches {
                let location = touch.locationInNode(camera!)
                let X_COOR_HALF_SCREEN = camera!.frame.size.width / 2
                
                /* Don't release grappling hook if jump button is pressed */
                if(location.x >= X_COOR_HALF_SCREEN) {
                    grapplingHook.removeFromParent()
                    boostXVelocity()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if(hero.physicsBody?.velocity.dx == 0) {
            hero.texture = STATIONARY_TEXTURE
        }
        
        scrollWater()
        
        /* Hero dies if he falls below screen */
        if(hero.position.y < 0) { gameState.enterState(GameOverState) }
        
        let timePassed = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameState.updateWithDeltaTime(timePassed)
    }
    
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
            /* Prevents grapplingHook from moving */
            grapplingHook.physicsBody?.dynamic = false
            
            /* The retracting motion of the grappling hook is simulated by a SKPhysicsJointSpring.
               The initial length of the spring is the distance between bodyA and bodyB when the 
               spring is first created. To simulate a retracting motion, we set the position of the hero
               equal to that of the grapplingHook, create the spring, then return the hero to its original
               position */
            let positionPlaceholder = hero.position
            hero.position = grapplingHook.position
            let springJoint = SKPhysicsJointSpring.jointWithBodyA(
                grapplingHook.physicsBody!,
                bodyB: hero.physicsBody!,
                anchorA: hero.position,
                anchorB: grapplingHook.position)
            physicsWorld.addJoint(springJoint)
            
            springJoint.damping = 4
            springJoint.frequency = 1
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
        
        
    }
    
    func setupPhysics() {
        /* This function changes the gravity of the world, gives
           all relevant nodes physics bodies, and creates a contactDelegate */
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -7)
        
        hero.setupPhysics()
        
        ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        ceiling1.physicsBody?.categoryBitMask = PhysicsCategory.Ceiling
        ceiling1.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ceiling1.physicsBody?.contactTestBitMask = PhysicsCategory.GrapplingHook
        
        physicsWorld.contactDelegate = self
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}
