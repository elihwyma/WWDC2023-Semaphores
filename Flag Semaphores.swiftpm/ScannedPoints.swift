//
//  ScannedPoints.swift
//  demoapp
//
//  Created by Amy While on 10/04/2023.
//

import Foundation
import CoreGraphics

public struct ScannedPoint {
    
    let leftWrist: CGPoint
    let leftElbow: CGPoint
    let leftShoulder: CGPoint
    let leftArmPosition: ArmPosition
    
    let rightWrist: CGPoint
    let rightElbow: CGPoint
    let rightShoulder: CGPoint
    let rightArmPosition: ArmPosition
    
    init?(points: [CGPoint]) {
        guard points.count == 6 else {
            return nil
        }
        
        // This is slightly confusing, this is the order at which they are fed in by the handler
        self.leftWrist = points[0]
        self.leftElbow = points[1]
        self.leftShoulder = points[2]
        self.rightShoulder = points[3]
        self.rightElbow = points[4]
        self.rightWrist = points[5]
        
        guard let rightArm = Self.armPosition(wrist: self.leftWrist, elbow: self.leftElbow, shoulder: self.leftShoulder, left: false),
              let leftArm = Self.armPosition(wrist: self.rightWrist, elbow: self.rightElbow, shoulder: self.rightShoulder, left: true) else {
                return nil
        }

        self.leftArmPosition = leftArm
        self.rightArmPosition = rightArm
    }
    
    static func armPosition(wrist: CGPoint, elbow: CGPoint, shoulder: CGPoint, left: Bool = true) -> ArmPosition? {
        // Calculate the angle between the two line segments (shoulder-elbow and elbow-wrist) using the arctangent function (atan2)
        // This takes into account the differences in gradients and provides the angle in radians
        let angle = atan2(shoulder.y - wrist.y, shoulder.x - wrist.x)
        
        // Convert the angle from radians to degrees
        let degrees = angle * 180 / .pi

        // Determine the arm position based on the angle in degrees
        switch degrees {
        case -180...(-157.5), 157.5...180:
            return .upCenter
        case -157.5...(-112.5):
            return .upLeft
        case -112.5...(-67.5):
            return .centerLeft
        case -67.5...(-22.5):
            return .downLeft
        case -22.5...(22.5):
            return .downCenter
        case 22.5...(67.5):
            return .downRight
        case 67.5...(112.5):
            return .centerRight
        case 112.5...(157.5):
            return .upRight
        default:
            return nil
        }
    }

}
