//
//  Hero.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/1/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class Hero: SKSpriteNode {
    let JUMP_VECTOR = CGVector(dx: 0, dy: 20)

    func jump() {
        /* NOTE: Restitution of ground and character
         sprite set to 0 to prevent bouncing */
        if(self.physicsBody?.velocity.dy == 0) {
            self.physicsBody?.applyImpulse(JUMP_VECTOR)
        }
    }
    
    func setupPhysics() {
        self.physicsBody?.categoryBitMask = PhysicsCategory.Hero
        self.physicsBody?.collisionBitMask = PhysicsCategory.Ground
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
    }
    
    
    /* Required initializers */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
