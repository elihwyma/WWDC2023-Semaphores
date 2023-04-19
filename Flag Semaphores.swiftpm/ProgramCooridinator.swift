//
//  ProgramCooridinator.swift
//  demoapp
//
//  Created by Amy While on 16/04/2023.
//

import Foundation

public class ProgramCooridinator {
    
    private var characters: [Characters]
    private let mode: ProgramMode
    private var hasCalibrated = false
    private var currentPiece: Characters? {
        didSet {
            if let currentPiece {
                delegate?.nextCharacter(character: currentPiece)
            }
        }
    }
    public var score = 0
    private var timeLeft = 60
    private var timer: Timer?
    
    public weak var delegate: ProgramCoordinatorDelegate?
    
    public init(mode: ProgramMode) {
        self.mode = mode
        self.characters = []
    }
    
    internal func scanned(point: ScannedPoint) {
        guard let character = Characters.flagFor(leftArm: point.leftArmPosition, rightArm: point.rightArmPosition) else {
            return
        }
        guard character == self.currentPiece else {
            return
        }
        if !hasCalibrated {
            if characters.isEmpty {
                self.currentPiece = nil
                self.hasCalibrated = true
                delegate?.didCompleteCalibration()
            } else {
                cyclePiece()
                return
            }
            return
        }
        switch mode {
        case .game:
            score += 1
            currentPiece = Characters.allCases.randomElement()
        case .learn:
            if characters.isEmpty {
                self.currentPiece = nil
                delegate?.didCompleteMode()
            } else {
                cyclePiece()
            }
        }
    }
    
    @objc internal func timerCycled() {
        if timeLeft == 0 {
            self.currentPiece = nil
            delegate?.didCompleteMode()
            return
        }
        delegate?.timerUpdate(secondsLeft: timeLeft)
        timeLeft -= 1
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCycled), userInfo: nil, repeats: false)
    }
    
    private func cyclePiece() {
        guard !characters.isEmpty else {
            return
        }
        self.currentPiece = characters.removeFirst()
    }
    
    public func start() {
        if !hasCalibrated {
            self.characters = [ .r, .d ]
        } else {
            switch mode {
            case .game:
                currentPiece = Characters.allCases.randomElement()
                timerCycled()
                return
            case .learn:
                characters = Characters.allCases.sorted { $0.rawValue < $1.rawValue }
            }
        }
        self.cyclePiece()
    }
    
}
