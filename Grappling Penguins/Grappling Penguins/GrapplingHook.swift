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
    let GRAPPLING_HOOK_RELEASE_VECTOR = CGVector(dx: 700, dy: 700)
    let GRAPPLING_HOOK_MAX_LENGTH: CGFloat = 300
    
    var yOffset: CGFloat = 0
    
    func shootGrapplingHook() {
        self.physicsBody?.velocity = GRAPPLING_HOOK_RELEASE_VECTOR
    }
    
    func animateGrapplingHook(startPoint: CGPoint, endPoint: CGPoint) {
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
        
        /* Setting up grappling line */
        grapplingLine.lineWidth = 2
        grapplingLine.strokeColor = UIColor.darkGrayColor()
        
        self.name = "GrapplingHook"
    }
    
    func createHookGraphic() {
        let box = UIBezierPath(roundedRect: CGRect(x: -10, y: -10, width: 20, height: 20), cornerRadius: 3)
        self.path = box.CGPath
        self.fillColor = UIColor.clearColor()
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
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Ceiling
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}