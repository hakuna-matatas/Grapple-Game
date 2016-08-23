//
//  Numbers.swift
//  Grappling Penguins
//
//  Created by Alan Gao on 7/29/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation
import SpriteKit


class Numbers {
    static let zero = SKSpriteNode(imageNamed: "Zero")
    static let one = SKSpriteNode(imageNamed: "One")
    static let two = SKSpriteNode(imageNamed: "Two")
    static let three = SKSpriteNode(imageNamed: "Three")
    static let four = SKSpriteNode(imageNamed: "Four")
    static let five = SKSpriteNode(imageNamed: "Five")
    static let six = SKSpriteNode(imageNamed: "Six")
    static let seven = SKSpriteNode(imageNamed: "Seven")
    static let eight = SKSpriteNode(imageNamed: "Eight")
    static let nine = SKSpriteNode(imageNamed: "Nine")
    
    static let bigZero = SKSpriteNode(imageNamed: "Big Zero")
    static let bigOne = SKSpriteNode(imageNamed: "Big One")
    static let bigTwo = SKSpriteNode(imageNamed: "Big Two")
    static let bigThree = SKSpriteNode(imageNamed: "Big Three")
    static let bigFour = SKSpriteNode(imageNamed: "Big Four")
    static let bigFive = SKSpriteNode(imageNamed: "Big Five")
    static let bigSix = SKSpriteNode(imageNamed: "Big Six")
    static let bigSeven = SKSpriteNode(imageNamed: "Big Seven")
    static let bigEight = SKSpriteNode(imageNamed: "Big Eight")
    static let bigNine = SKSpriteNode(imageNamed: "Big Nine")
    
    /** Array that contains small sprites of digits 0-9. Used to display player's old highscore (on the gameover screen) and the player's current score */
    static let allSmallNumbers: [SKSpriteNode] = [zero, one, two, three, four, five, six, seven, eight, nine]
    
    /** Array that contains big sprites of digits 0-9. Used to display player's final score */
    static let allBigNumbers: [SKSpriteNode] = [bigZero, bigOne, bigTwo, bigThree, bigFour, bigFive, bigSix, bigSeven, bigEight, bigNine]
    
    
    static func getSmallNumber(number: Int) -> SKSpriteNode {
        return allSmallNumbers[number].copy() as! SKSpriteNode
    }
    
    static func getBigNumber(number: Int) -> SKSpriteNode {
        return allBigNumbers[number].copy() as! SKSpriteNode
    }
    
    /** Returns an array containing all the digits of a number */
    static func parseDigits(number: Int) -> [Int] {
        var numberCopy = number
        var digitArray = [Int]()
        
        while(numberCopy > 0) {
            let digit = numberCopy % 10
            digitArray.insert(digit, atIndex: 0)
            
            numberCopy = numberCopy / 10
        }
        
        return digitArray
    }
    
    /** Returns a sprite representation of the score */
    static func createNumberSprite(inout containerNode: SKNode, score: Int, isMainScore: Bool, spaceFromFirstNum: CGFloat) {
        let spaceBwLetters: CGFloat = 1
        var spaceFromFirstNumber = spaceFromFirstNum
        var numberSprite: SKSpriteNode!
        
        let digits = Numbers.parseDigits(score)
        
        for digit in digits {
            if(isMainScore) {
                numberSprite = Numbers.getBigNumber(digit)
            }
            else {
                numberSprite = Numbers.getSmallNumber(digit)
            }
            numberSprite.anchorPoint.x = 0
            containerNode.addChild(numberSprite)
            
            numberSprite.position.x = spaceFromFirstNumber
            spaceFromFirstNumber += numberSprite.size.width + spaceBwLetters
        }
        
        if(isMainScore) {
            let METER_LABEL = SKSpriteNode(imageNamed: "Meters")
            METER_LABEL.anchorPoint.x = 0
            containerNode.addChild(METER_LABEL)
            METER_LABEL.position = CGPoint(x: spaceFromFirstNumber, y: -5)
        }
    }
    
    static var range: UInt32 = 15
    static func getRandYCoorCloud() -> CGFloat {
        return CGFloat((arc4random_uniform(range) + 345))
    }   
    
}