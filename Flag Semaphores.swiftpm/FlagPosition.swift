//
//  File.swift
//  
//
//  Created by Amy While on 08/04/2023.
//

import Foundation

struct FlagPosition: Hashable {
    
    let character: Characters
    
    let leftArm: ArmPosition
    
    let rightArm: ArmPosition
    
    static func ==(lhs: FlagPosition, rhs: FlagPosition) -> Bool {
        lhs.character == rhs.character
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(character)
    }
    
}
