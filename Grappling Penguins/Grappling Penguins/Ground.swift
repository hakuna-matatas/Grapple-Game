//
//  Ground.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/12/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit

class Ground: SKSpriteNode {
    
    
    
    /* Required initializers */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
