//
//  Hero.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/1/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class Hero: SKSpriteNode {
    let HERO_MASS = CGFloat(0.03)
    let JUMP_VECTOR = CGVector(dx: 0, dy: 20)
    
    func jump() {
        if let physBody = self.physicsBody {
            /* NOTE: Restitution of ground and character
             sprite set to 0 to prevent bouncing */
            if(physBody.velocity.dy == 0) {
                //self.physicsBody?.applyImpulse(JUMP_VECTOR)
                physBody.applyImpulse(JUMP_VECTOR)
            }
        }
    }
    
    func setupPhysics() {
        if let physBody = self.physicsBody {
            physBody.categoryBitMask = PhysicsCategory.Hero
            physBody.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Cloud
            physBody.contactTestBitMask = PhysicsCategory.None
            
            physBody.dynamic = true
            physBody.affectedByGravity = true
            physBody.allowsRotation = false
            
            physBody.mass = HERO_MASS
        }
    }
    
    
    /* Required initializers */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}