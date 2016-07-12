//
//  GrapplingHook.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/11/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class GrapplingHook: SKShapeNode {
    var grapplingLine: SKShapeNode = SKShapeNode()
    let GRAPPLING_HOOK_RELEASE_VECTOR = CGVector(dx: 5, dy: 5)
    let GRAPPLING_HOOK_RETRACT_VECTOR = CGVector(dx: -2, dy: -2)
    
    func shootGrapplingHook() {
        self.physicsBody?.applyImpulse(GRAPPLING_HOOK_RELEASE_VECTOR)
    }
    
    func retractGrapplingHook() {
        self.physicsBody?.applyImpulse(GRAPPLING_HOOK_RETRACT_VECTOR)
    }
    
    func animateGrapplingHook(startPoint: CGPoint, endPoint: CGPoint) {
        let PATH = UIBezierPath()
        PATH.moveToPoint(endPoint)
        PATH.addLineToPoint(startPoint)
        grapplingLine.path = PATH.CGPath
        
        grapplingLine.lineWidth = 4
        grapplingLine.strokeColor = UIColor.darkGrayColor()
    }
    
    init(heroPosition: CGPoint) {
        super.init()
        initPhysBody(heroPosition)
        self.addChild(grapplingLine)
    }
    
    func initPhysBody(heroPosition: CGPoint) {
        let RECT_SIZE = CGSize(width: 28, height: 28)
        let HOOK_NODE_PHYS_BODY = SKPhysicsBody(rectangleOfSize: RECT_SIZE)
        self.physicsBody = HOOK_NODE_PHYS_BODY
        
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.GrapplingHook
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        self.position = heroPosition
        
        //Debugging purposes
        self.lineWidth = 4
        self.strokeColor = UIColor.darkGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
