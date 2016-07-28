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
    var iceberg: SKSpriteNode!
    var sky: SKSpriteNode!
    
    /* An array of all the instantiated clouds */
    var cloudArray = [SKSpriteNode]()
    
    var hero: Hero!
    var grapplingHook: GrapplingHook!
    var grapplingHookMadeContact = false
    var oldCameraPositionRelativeToScene = CGPoint(x: 333.5, y: 0)
    
    /* Used to scroll things across the world */
    var waterScrollNode: SKNode!
    
    let STATIONARY_TEXTURE = SKTexture(imageNamed: "Stationary Penguin")
    let FLYING_TEXTURE = SKTexture(imageNamed: "Flying")
    
    let CLOUD_WIDTH: CGFloat = 126.0
    var distanceBwClouds: CGFloat = 0
    
    var distanceTravelled: Int = 0 {
        didSet {
            distanceTravelledLabel.text = String(distanceTravelled)
        }
    }
    var distanceTravelledLabel: SKLabelNode!
    var highScore = 0
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        setupPhysics()
        addClouds(2)
        
        readyState = ReadyState(scene: self)
        playingState = PlayingState(scene: self)
        gameOverState = GameOverState(scene: self)
        winState = WinState(scene: self)
        
        gameState = GKStateMachine(states: [readyState, playingState, gameOverState, winState])
        gameState.enterState(ReadyState)
        
        if(userDefaults.valueForKey("HighScore") != nil) {
            self.highScore = userDefaults.valueForKey("HighScore") as! Int
        }
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
        distanceTravelled = Int(self.hero.position.x)/100
        
        let spaceBwCloudAndScreen = (self.camera!.position.x + 1.5*667) - cloudArray.last!.position.x
        
        if(spaceBwCloudAndScreen > CLOUD_WIDTH + distanceBwClouds) {
            let numCloudsToAdd = Int(spaceBwCloudAndScreen/(CLOUD_WIDTH + distanceBwClouds))
            addClouds(numCloudsToAdd)
        }
        
        /* Removing clouds we have passed */
        for cloud in cloudArray {
            if(cloud.position.x < self.camera!.position.x - 400.5) {
                cloud.removeFromParent()
                cloudArray.removeAtIndex(cloudArray.indexOf(cloud)!)
            }
        }
        
        /* Increase difficulty */
        switch distanceTravelled {
        case 50:
            distanceBwClouds += 25
        case 100:
            distanceBwClouds += 50
            self.physicsWorld.gravity.dy += 0.5
        case 150:
            distanceBwClouds += 50
            self.physicsWorld.gravity.dy += 0.5
        default:
            break
        }
        
        
        if(hero.physicsBody?.velocity.dx == 0) {
            hero.texture = STATIONARY_TEXTURE
        }
        
        /* Hero dies if he falls below screen */
        if(hero.position.y < 0) { gameState.enterState(GameOverState) }
        
        let timePassed = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        gameState.updateWithDeltaTime(timePassed)
        
        Scroll.scrollWater(self)
        Scroll.scrollIceberg(self, oldCameraPositionRelativeToScene: oldCameraPositionRelativeToScene)
        
        oldCameraPositionRelativeToScene = camera!.convertPoint(camera!.position, toNode: self)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if(nodeA!.name == "GrapplingHook" || nodeB!.name == "GrapplingHook") {
            grapplingHookMadeContact = true
            
            let snow1Emitter = SnowEmitter.createEmitter("Snow1.sks", emitterPosition: nodeA!.position)
            let snow2Emitter = SnowEmitter.createEmitter("Snow2.sks", emitterPosition: nodeA!.position)
            
            let emitSnowSKActions = SnowEmitter.emitSnow(self, snow1Emitter: snow1Emitter, snow2Emitter: snow2Emitter)
            
            self.runAction(SKAction.sequence(emitSnowSKActions))
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
    
    func addClouds(numberOfClouds: Int) {
        var xCoor = cloudArray.last?.position.x ?? 207.5
        xCoor += CLOUD_WIDTH + distanceBwClouds
        
        for _ in 0...numberOfClouds {
            let cloud = SKSpriteNode(imageNamed: "Cloud.png")
            cloud.physicsBody = SKPhysicsBody(texture: cloud.texture!, size: cloud.size)
            
            cloud.physicsBody?.categoryBitMask = PhysicsCategory.Cloud
            cloud.physicsBody?.collisionBitMask = PhysicsCategory.Hero
            cloud.physicsBody?.contactTestBitMask = PhysicsCategory.GrapplingHook
            
            cloud.physicsBody?.dynamic = false
            cloud.physicsBody?.affectedByGravity = false
            cloud.physicsBody?.allowsRotation = false
            
            self.addChild(cloud)
            
            let randYCoor = CGFloat(arc4random_uniform(70) + 305)
            
            let cloudPosition = CGPoint(x: xCoor, y: randYCoor)
            cloud.position = cloudPosition
            cloudArray.append(cloud)
            
            xCoor += CLOUD_WIDTH + distanceBwClouds
        }
    }
    
    func boostXVelocity() {
        hero.physicsBody!.applyImpulse(CGVector(dx: 5, dy: 0))
    }
    
    func initializeVars() {
        ground = self.childNodeWithName("ground") as! SKSpriteNode
        water1 = self.childNodeWithName("//water1") as! SKSpriteNode
        water2 = self.childNodeWithName("//water2") as! SKSpriteNode
        iceberg = self.childNodeWithName("//iceberg") as! SKSpriteNode
        sky = self.childNodeWithName("//sky") as! SKSpriteNode
        waterScrollNode = self.childNodeWithName("waterScrollNode")
        hero = self.childNodeWithName("hero") as! Hero
        distanceTravelledLabel = self.childNodeWithName("//distanceTravelledLabel") as! SKLabelNode
    }
    
    func setupPhysics() {
        /* This function changes the gravity of the world, gives
         all relevant nodes physics bodies, and creates a contactDelegate */
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        physicsWorld.contactDelegate = self
        
        hero.setupPhysics()
        
        ground.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
    }
}

extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}
