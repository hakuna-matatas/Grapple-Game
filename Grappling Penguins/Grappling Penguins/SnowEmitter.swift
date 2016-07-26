//
//  SnowEmitter.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/21/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class SnowEmitter {
    
    static func createEmitter(emitterName: String, emitterPosition: CGPoint) -> SKEmitterNode {
        let NUM_PARTICLES_TO_EMIT = 5
        
        let snowEmitter = SKEmitterNode(fileNamed: emitterName)!
        snowEmitter.position = emitterPosition
        snowEmitter.numParticlesToEmit = NUM_PARTICLES_TO_EMIT
        
        return snowEmitter
    }
    
    static func emitSnow(scene: GameScene, snow1Emitter: SKEmitterNode, snow2Emitter: SKEmitterNode)                -> [SKAction]{
        
        let addEmitters = SKAction.runBlock({
            scene.addChild(snow1Emitter)
            scene.addChild(snow2Emitter)
        })
        
        let NUM_PARTICLES_EMITTED = CGFloat(5)
        let PARTICLE_LIFETIME = CGFloat(3)
        let emitterDuration = NUM_PARTICLES_EMITTED * PARTICLE_LIFETIME
        
        let delay = SKAction.waitForDuration(NSTimeInterval(emitterDuration))
        
        let remove = SKAction.runBlock({
            snow1Emitter.removeFromParent()
            snow2Emitter.removeFromParent()
        })
        
        return [addEmitters, delay, remove]
    }
}
