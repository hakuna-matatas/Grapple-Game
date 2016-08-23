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
    
    /** GKStates have update functions, but require a NSTimeInterval
     as a parameter. We subtract lastUpdateTime from currentTime (found
     in the update method), thus finding the time between update calls */
    var lastUpdateTime: CFTimeInterval = 0
    
    /* These sprite nodes make up the gamescene. */
    var ground: SKSpriteNode!
    var water1: SKSpriteNode!
    var water2: SKSpriteNode!
    var iceberg: SKSpriteNode!
    var sky: SKSpriteNode!
    var startCloud: SKSpriteNode!
    
    /** An array of all the instantiated clouds */
    var cloudArray = [SKSpriteNode]()
    
    var hero: Hero!
    var grapplingHook: GrapplingHook!
    var grapplingHookMadeContact = false
    
    /** Scrolls the icebergs */
    var oldCameraPosition = CGPoint(x: 333.5, y: 0)
    /** Scrolls the water */
    var waterScrollNode: SKNode!
    
    let STATIONARY_TEXTURE = SKTexture(imageNamed: "Stationary Penguin")
    let FLYING_TEXTURE = SKTexture(imageNamed: "Flying Penguin")
    let RELEASE_HOOK_TEXTURE = SKTexture(imageNamed: "Release Hook Penguin")
    
    let CLOUD_WIDTH: CGFloat = 126.0
    var distanceBwClouds: CGFloat = 0
    
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        setupPhysics()
        addClouds(2)
        
        readyState = ReadyState(scene: self)
        playingState = PlayingState(scene: self)
        gameOverState = GameOverState(scene: self)
        
        gameState = GKStateMachine(states: [readyState, playingState, gameOverState])
        gameState.enterState(ReadyState)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(gameState.currentState == gameOverState) { return }
        
        hero.texture = RELEASE_HOOK_TEXTURE
        hero.removeAllActions()
        hero.runAction(SKAction.rotateToAngle(0, duration: 0.1))

        /* Initializes grappling hook and shoots it */
        grapplingHook = GrapplingHook(heroPosition: hero.position)
        self.addChild(grapplingHook)
        grapplingHook.shootGrapplingHook()
        
        /* Prevents user from releasing multiple grappling hooks */
        self.userInteractionEnabled = false
        
        /* Game starts when player taps the screen */
        if(gameState.currentState == readyState) {
            gameState.enterState(PlayingState)
        }
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hero.texture = FLYING_TEXTURE
        hero.removeAllActions()
        hero.runAction(SKAction.rotateToAngle(-0.42, duration: 0.25))
        
        if let _ = grapplingHook {
            grapplingHook.removeFromParent()
            grapplingHook.isConnected = false
        }
        
        /* Allows user to release new grappling hook */
        self.userInteractionEnabled = true
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        scrollWorld()
        
        if(gameState.currentState == gameOverState) { return }
        
        /* Prevents access to cloud array if there's nothing in it */
        if let lastCloud = cloudArray.last {
            
            /* There are always 1.5 screens widths of clouds that are generated */
            let spaceBwLastCloudAndScreen = (self.camera!.position.x + 1.5*667) - lastCloud.position.x
            if(spaceBwLastCloudAndScreen > CLOUD_WIDTH + distanceBwClouds) {
                let numCloudsToAdd = Int(ceil(spaceBwLastCloudAndScreen/(CLOUD_WIDTH + distanceBwClouds)))
                addClouds(numCloudsToAdd)
            }
        }
        
        /* Removing clouds we have passed */
        for cloud in cloudArray {
            if(cloud.position.x < self.camera!.position.x - 800.5) {
                cloud.removeFromParent()
                cloudArray.removeAtIndex(cloudArray.indexOf(cloud)!)
            }
        }
                
        let timePassed = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameState.updateWithDeltaTime(timePassed)
    }
    
    func scrollWorld() {
        Scroll.scrollWater(self.camera!, scrollNode: waterScrollNode)
        let cameraDisplacement = self.camera!.position.x - oldCameraPosition.x
        Scroll.scrollIceberg(iceberg, cameraDisplacement: cameraDisplacement)
        
        oldCameraPosition = self.camera!.position
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        let nodeACategoryBitMask = nodeA!.physicsBody?.categoryBitMask
        let nodeBCategoryBitMask = nodeB!.physicsBody?.categoryBitMask
        
        if(nodeACategoryBitMask == PhysicsCategory.Cloud ||
           nodeBCategoryBitMask == PhysicsCategory.Cloud) {
            grapplingHookMadeContact = true
            
            var cloud: SKSpriteNode!
            
            if(nodeACategoryBitMask == PhysicsCategory.Cloud) {
                cloud = nodeA as! SKSpriteNode
            }
            else if(nodeBCategoryBitMask == PhysicsCategory.Cloud) {
                cloud = nodeB as! SKSpriteNode
            }
            
            let scaleUp = SKAction.scaleTo(1.05, duration: 0.1)
            let scaleDown = SKAction.scaleTo(0.95, duration: 0.1)
            let scaleNormal = SKAction.scaleTo(1, duration: 0.1)
            let cloudSeq = SKAction.sequence([scaleUp, scaleDown, scaleUp, scaleNormal])
            
            cloud.runAction(cloudSeq)
        }
    }
    
    override func didSimulatePhysics() {
        moveCamera()
        
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
            grapplingHook.isConnected = true
            
            hero.physicsBody!.applyImpulse(CGVector(dx: 5, dy: 0))
        }
    }
    
    var maxCameraPosition: CGFloat = 0
    func moveCamera() {
        if(self.hero.position.x + 237 > maxCameraPosition) {
            
            /* The camera follows the penguin */
            self.camera!.position = CGPoint(x: self.hero.position.x + 237, y: self.camera!.position.y)
            maxCameraPosition = self.camera!.position.x
        }
    }
    
    func addClouds(numberOfClouds: Int) {
        var xCoor = cloudArray.last?.position.x ?? 418
        xCoor += CLOUD_WIDTH + distanceBwClouds
        
        for _ in 0...numberOfClouds {
            let cloud = SKSpriteNode(imageNamed: "Cloud.png")
            cloud.physicsBody = SKPhysicsBody(texture: cloud.texture!, size: cloud.size)
            
            cloud.physicsBody?.categoryBitMask = PhysicsCategory.Cloud
            cloud.physicsBody?.collisionBitMask = PhysicsCategory.None
            cloud.physicsBody?.contactTestBitMask = PhysicsCategory.GrapplingHook
            
            cloud.physicsBody?.dynamic = false
            cloud.physicsBody?.affectedByGravity = false
            cloud.physicsBody?.allowsRotation = false
            
            self.addChild(cloud)
            
            let randYCoor = Numbers.getRandYCoorCloud()
            
            let cloudPosition = CGPoint(x: xCoor, y: randYCoor)
            cloud.position = cloudPosition
            cloudArray.append(cloud)
            
            xCoor += CLOUD_WIDTH + distanceBwClouds
        }
    }
    
    func initializeVars() {
        ground = self.childNodeWithName("ground") as! SKSpriteNode
        water1 = self.childNodeWithName("//water1") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        iceberg = self.childNodeWithName("//iceberg") as! SKSpriteNode
        sky = self.childNodeWithName("//sky") as! SKSpriteNode
        startCloud = self.childNodeWithName("startCloud") as! SKSpriteNode
        waterScrollNode = self.childNodeWithName("waterScrollNode")
        hero = self.childNodeWithName("hero") as! Hero
    }
    
    /** This function changes the gravity of the world, gives
     all relevant nodes physics bodies, and creates a contactDelegate */
    func setupPhysics() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        physicsWorld.contactDelegate = self
        
        hero.setupPhysics()
        
        ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        startCloud.physicsBody?.categoryBitMask = PhysicsCategory.Cloud
        startCloud.physicsBody!.collisionBitMask = PhysicsCategory.Hero
        startCloud.physicsBody!.contactTestBitMask = PhysicsCategory.GrapplingHook
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}
