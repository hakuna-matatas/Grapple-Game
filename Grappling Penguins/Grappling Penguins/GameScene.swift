//
//  GameScene.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 6/30/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    /* Declaring variables */
    var groundScrollNode: SKNode!
    var groundSprite1: SKSpriteNode!
    var groundSprite2: SKSpriteNode!
    let groundScrollSpeed: CGFloat = 0.0
    
    var hero: Hero!
    var grapplingHook: GrapplingHook!
    
    var isTouching: Bool = false
    
    override func didMoveToView(view: SKView) {
        initializeVars()
        hero.setupPhysics()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching = true
        
        for touch in touches {
            let location = touch.locationInNode(self)
            let X_COOR_HALF_SCREEN = self.size.width / 2
            
            if(location.x >= X_COOR_HALF_SCREEN) {
                //Right side of screen
                if(isTouching) {
                    grapplingHook.shootGrapplingHook()
                }
            }
            else {
                //Left side of screen
                hero.jump()
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        //scrollGround()
        let startPoint = convertPoint(hero.position, toNode: grapplingHook)
        let endPoint = convertPoint(grapplingHook.position, toNode: grapplingHook)
        grapplingHook.animateGrapplingHook(startPoint, endPoint: endPoint)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouching = false
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
        
        groundSprite1.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        groundSprite1.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        groundSprite1.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        groundSprite2.physicsBody!.categoryBitMask = PhysicsCategory.Ground
        groundSprite2.physicsBody?.collisionBitMask = PhysicsCategory.Hero
        groundSprite2.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        hero = self.childNodeWithName("hero") as! Hero
        
        grapplingHook = GrapplingHook(heroPosition: hero.position)
        self.addChild(grapplingHook)
    }
}
