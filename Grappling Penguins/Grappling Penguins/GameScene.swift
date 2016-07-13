//
//  GameScene.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 6/30/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    /* Declaring variables */
    var groundScrollNode: SKNode!
    var groundSprite1: SKSpriteNode!
    var groundSprite2: SKSpriteNode!
    var ceilingSprite1: SKSpriteNode!
    let groundScrollSpeed: CGFloat = 0.0
    
    var hero: Hero!
    var grapplingHook: GrapplingHook!
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        hero.setupPhysics()
        physicsWorld.contactDelegate = self
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(camera!)
            let X_COOR_HALF_SCREEN = camera!.frame.size.width / 2
            
            if(location.x >= X_COOR_HALF_SCREEN) {
                grapplingHook = GrapplingHook(heroPosition: hero.position)
                self.addChild(grapplingHook)
                
                grapplingHook.shootGrapplingHook()  
            }
            else {
                //Left side of screen
                hero.jump()
            }
        }
    }
    
    let MIN_DIST_HOOK_AND_HERO = CGFloat(50)
    override func update(currentTime: CFTimeInterval) {
        camera!.position = CGPoint(x: hero.position.x, y: camera!.position.y)
        
        if let _ = grapplingHook {
            if((grapplingHook.position.x - hero.position.x) < MIN_DIST_HOOK_AND_HERO &&
                grapplingHookConnected == false) {
                grapplingHook.position.x += MIN_DIST_HOOK_AND_HERO
            }
            
            let startPoint = convertPoint(hero.position, toNode: grapplingHook)
            let endPoint = convertPoint(grapplingHook.position, toNode: grapplingHook)
            grapplingHook.animateGrapplingHook(startPoint, endPoint: endPoint)
            
            if(startPoint.distance(endPoint) > grapplingHook.GRAPPLING_HOOK_MAX_LENGTH) {
                grapplingHook.removeFromParent()
            }
            
            boostXVelocity()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Don't release grappling hook if jump button is pressed */
        if let _ = grapplingHook {
            for touch in touches {
                let location = touch.locationInNode(camera!)
                let X_COOR_HALF_SCREEN = camera!.frame.size.width / 2
                
                if(location.x >= X_COOR_HALF_SCREEN) {
                    grapplingHook.removeFromParent()
                }
            }
            grapplingHookConnected = false
        }
    }
    
    var grapplingHookMadeContact = false
    var grapplingHookConnected = false
    func didBeginContact(contact: SKPhysicsContact) {
        grapplingHookMadeContact = true
        grapplingHookConnected = true
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
        hero.physicsBody!.velocity.dx += 1
    }
    
    func scrollGround() {
        groundScrollNode.position.x -= groundScrollSpeed
        
        for ground in groundScrollNode.children as! [SKSpriteNode] {
            let groundPosition = groundScrollNode.convertPoint(ground.position, toNode: self)
            
            if(groundPosition.x <= -(ground.size.width / 2)) {
                let newPosition = CGPoint(x: self.size.width + (ground.size.width / 2), y: ground.position.y)
                ground.position = self.convertPoint(newPosition, toNode: groundScrollNode)
            }
        }
    }
    
    func initializeVars() {
        groundScrollNode = self.childNodeWithName("groundScrollNode")
        groundSprite1 = self.childNodeWithName("//groundSprite1") as! SKSpriteNode
        groundSprite2 = self.childNodeWithName("//groundSprite2") as! SKSpriteNode
        ceilingSprite1 = self.childNodeWithName("ceilingSprite1") as! SKSpriteNode
        
        groundSprite1.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        groundSprite1.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        groundSprite1.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        groundSprite2.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        groundSprite2.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        groundSprite2.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        ceilingSprite1.physicsBody?.categoryBitMask = PhysicsCategory.Ceiling
        ceilingSprite1.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        ceilingSprite1.physicsBody?.contactTestBitMask = PhysicsCategory.GrapplingHook
        
        hero = self.childNodeWithName("hero") as! Hero
    }
}


extension CGPoint {
    func distance(point: CGPoint) -> CGFloat {
        return abs(CGFloat(hypotf(Float(point.x - x), Float(point.y - y))))
    }
}
