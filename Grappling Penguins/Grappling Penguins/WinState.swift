//
//  WinState.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/19/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit
import GameplayKit

class WinState: GKState {
    unowned var scene: GameScene
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        
    }
}
