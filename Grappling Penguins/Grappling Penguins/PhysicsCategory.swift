//
//  PhysicsCategory.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/12/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:                UInt32 = 0b00000000
    static let GrapplingHook:       UInt32 = 0b00000010
    static let Hero:                UInt32 = 0b00000100
    static let Ring:                UInt32 = 0b00001000
    static let Ground:              UInt32 = 0b00010000
    static let Cloud:               UInt32 = 0b00100000
    static let Goal:                UInt32 = 0b01000000
    static let Obstacle:            UInt32 = 0b10000000
}