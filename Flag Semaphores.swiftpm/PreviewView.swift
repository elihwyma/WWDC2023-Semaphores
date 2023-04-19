//
//  TwoTypeLabel.swift
//  demoapp
//
//  Created by Amy While on 19/04/2023.
//

import UIKit

class PreviewView: UIView {
    
    let firstLabel: FadingLabel = {
        let label = FadingLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold, design: .rounded)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.text = "Calibrating, please do:"
        label.textAlignment = .center
        return label
    }()
    
    lazy var secondLabel: FadingLabel = {
        let label = FadingLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold, design: .rounded)
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let mode: ProgramMode
    public var hasCalibrated = false {
        didSet {
            if hasCalibrated {
                switch mode {
                case .game:
                    secondLabel.text = ""
                case .learn:
                    imageView.image = nil
                }
            }
        }
    }
    
    init(mode: ProgramMode) {
        self.mode = mode
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2.5
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(firstLabel)
        
        switch mode {
        case .game: stackView.addArrangedSubview(secondLabel)
        case .learn: stackView.addArrangedSubview(imageView)
        }

        addSubview(stackView)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: stackView.topAnchor),
            leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    public func set(time: Int) {
        guard mode == .game else {
            return
        }
        firstLabel.set(text: "\(time) seconds left", animate: true)
        guard time <= 10 else {
            return
        }
        firstLabel.textColor = time % 2 == 0 ? .systemRed : .label
    }
    
    public func set(character: Characters) {
        #if DEBUG
        print("Character is \(dump(character.flagPosition))")
        #endif
        if mode == .game {
            secondLabel.set(text: character.description, animate: true)
        } else {
            imageView.image = UIImage(named: character.description)
            if hasCalibrated {
                firstLabel.set(text: character.description, animate: true)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
