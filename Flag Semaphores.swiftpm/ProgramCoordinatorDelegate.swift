//
//  ProgramCoordinatorDelegate.swift
//  demoapp
//
//  Created by Amy While on 19/04/2023.
//

import Foundation

public protocol ProgramCoordinatorDelegate: AnyObject {
    
    func didCompleteMode()
    func didCompleteCalibration()
    func nextCharacter(character: Characters)
    func timerUpdate(secondsLeft: Int)
    
}
