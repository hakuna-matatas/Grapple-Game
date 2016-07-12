//
//  PhysicsCategory.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/12/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None:                UInt32 = 0b00000
    static let GrapplingHook:       UInt32 = 0b00010
    static let Hero:                UInt32 = 0b00100
    static let Ring:                UInt32 = 0b01000
    static let Ground:              UInt32 = 0b10000
}