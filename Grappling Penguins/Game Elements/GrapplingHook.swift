//
//  GrapplingHook.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/11/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class GrapplingHook: SKShapeNode {
    /* The line that connects hero and grapplingHook */
    var grapplingLine: SKShapeNode = SKShapeNode()
    
    var isConnected = false
    
    let GRAPPLING_HOOK_RELEASE_VECTOR = CGVector(dx: 700, dy: 700)
    let GRAPPLING_HOOK_MAX_LENGTH: CGFloat = 300
    
    func shootGrapplingHook() {
        self.physicsBody!.velocity = GRAPPLING_HOOK_RELEASE_VECTOR
        
        if let hero = self.parent?.childNodeWithName("hero") {
            /* Ensures grapplingHook always released at ~45 degree angle from hero */
            self.physicsBody!.velocity.dx += hero.physicsBody!.velocity.dx
            self.physicsBody!.velocity.dy += hero.physicsBody!.velocity.dy
        }
    }

    func animateGrapplingHook(startPoint: CGPoint, endPoint: CGPoint) {
        /* Draws a line from startPoint to endPoint */
        let PATH = UIBezierPath()
        PATH.moveToPoint(endPoint)
        PATH.addLineToPoint(startPoint)
        
        grapplingLine.path = PATH.CGPath
    }
    
    init(heroPosition: CGPoint) {
        super.init()
        
        /* Setting up grappling hook */
        initPhysBody()
        createHookGraphic()
        self.position = heroPosition
        self.addChild(grapplingLine)
        grapplingLine.position = CGPoint(x: -self.frame.width/4, y: self.frame.height/4)
        
        /* Setting up grappling line */
        grapplingLine.lineWidth = 1
        grapplingLine.strokeColor = UIColor.whiteColor()
        
        /* Used in GameScene.swift's didBeginContact method to determine
         whether the hook has hit something it can attach onto */
        self.name = "GrapplingHook"
    }
    
    func createHookGraphic() {
        /* Creates a triangle */
        let trianglePath = UIBezierPath()
        trianglePath.moveToPoint(CGPoint(x: 0, y: 0))
        trianglePath.addLineToPoint(CGPoint(x: -7.07, y: 7.07))
        trianglePath.addLineToPoint(CGPoint(x: 7.07, y: 14.14))
        
        self.path = trianglePath.CGPath
        self.fillColor = UIColor.whiteColor()
        self.lineWidth = 0
    }
    
    func initPhysBody() {
        let RECT_SIZE = CGSize(width: 18, height: 18)
        let HOOK_NODE_PHYS_BODY = SKPhysicsBody(rectangleOfSize: RECT_SIZE)
        self.physicsBody = HOOK_NODE_PHYS_BODY
        
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.GrapplingHook
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Cloud
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}