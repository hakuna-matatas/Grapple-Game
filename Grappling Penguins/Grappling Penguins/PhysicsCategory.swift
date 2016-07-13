//
//  PhysicsCategory.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/12/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:                UInt32 = 0b000000
    static let GrapplingHook:       UInt32 = 0b000010
    static let Hero:                UInt32 = 0b000100
    static let Ring:                UInt32 = 0b001000
    static let Ground:              UInt32 = 0b010000
    static let Ceiling:             UInt32 = 0b100000
}