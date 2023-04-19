//
//  File.swift
//  
//
//  Created by Amy While on 08/04/2023.
//

import Foundation

public enum ArmPosition: UInt8, CustomStringConvertible {
    
    case upCenter = 0 // North
    case upRight = 1 // North-East
    case centerRight = 2 // East
    case downRight = 3 // South-East
    case downCenter = 4 // South
    case downLeft = 5 // South-West
    case centerLeft = 6 // West
    case upLeft = 7 // North-West
    
    public var description: String {
        switch self {
        case .upCenter:
            return "North"
        case .upRight:
            return "North-East"
        case .centerRight:
            return "East"
        case .downRight:
            return "South-East"
        case .downCenter:
            return "South"
        case .downLeft:
            return "South-West"
        case .centerLeft:
            return "West"
        case .upLeft:
            return "North-West"
        }
    }
    
}
