//
//  File.swift
//  
//
//  Created by Amy While on 08/04/2023.
//

import Foundation

public enum Characters: Character, CaseIterable, CustomStringConvertible {
    
    case a = "A"
    case b = "B"
    case c = "C"
    case d = "D"
    case e = "E"
    case f = "F"
    case g = "G"
    case h = "H"
    case i = "I"
    case j = "J"
    case k = "K"
    case l = "L"
    case m = "M"
    case n = "N"
    case o = "O"
    case p = "P"
    case q = "Q"
    case r = "R"
    case s = "S"
    case t = "T"
    case u = "U"
    case v = "V"
    case w = "W"
    case x = "X"
    case y = "Y"
    case z = "Z"
    
    public var description: String {
        String(self.rawValue)
    }
    
    var flagPosition: FlagPosition {
        switch self {
        case .a: return FlagPosition(character: self, leftArm: .downLeft, rightArm: .downCenter)
        case .b: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .downCenter)
        case .c: return FlagPosition(character: self, leftArm: .upLeft, rightArm: .downCenter)
        case .d: return FlagPosition(character: self, leftArm: .upCenter, rightArm: .downCenter)
        case .e: return FlagPosition(character: self, leftArm: .downCenter, rightArm: .upRight)
        case .f: return FlagPosition(character: self, leftArm: .downCenter, rightArm: .centerRight)
        case .g: return FlagPosition(character: self, leftArm: .downCenter, rightArm: .downRight)
        case .h: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .downLeft)
        case .i: return FlagPosition(character: self, leftArm: .upLeft, rightArm: .downLeft)
        case .j: return FlagPosition(character: self, leftArm: .upCenter, rightArm: .centerRight)
        case .k: return FlagPosition(character: self, leftArm: .downLeft, rightArm: .upCenter)
        case .l: return FlagPosition(character: self, leftArm: .downLeft, rightArm: .upRight)
        case .m: return FlagPosition(character: self, leftArm: .downLeft, rightArm: .centerRight)
        case .n: return FlagPosition(character: self, leftArm: .downLeft, rightArm: .downRight)
        case .o: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .upLeft)
        case .p: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .upCenter)
        case .q: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .upRight)
        case .r: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .centerRight)
        case .s: return FlagPosition(character: self, leftArm: .centerLeft, rightArm: .downRight)
        case .t: return FlagPosition(character: self, leftArm: .upLeft, rightArm: .upCenter)
        case .u: return FlagPosition(character: self, leftArm: .upLeft, rightArm: .upRight)
        case .v: return FlagPosition(character: self, leftArm: .upCenter, rightArm: .downRight)
        case .w: return FlagPosition(character: self, leftArm: .upRight, rightArm: .centerRight)
        case .x: return FlagPosition(character: self, leftArm: .upRight, rightArm: .downRight)
        case .y: return FlagPosition(character: self, leftArm: .upLeft, rightArm: .centerRight)
        case .z: return FlagPosition(character: self, leftArm: .downRight, rightArm: .centerRight)
        }
    }
    
    static public func flagFor(leftArm: ArmPosition, rightArm: ArmPosition) -> Characters? {
        for character in Self.allCases {
            let flagPosition = character.flagPosition
            if flagPosition.leftArm == leftArm && flagPosition.rightArm == rightArm {
                return character
            }
        }
        return nil
    }
 
}
