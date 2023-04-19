//
//  IntroductionViewController.swift
//  demoapp
//
//  Created by Amy While on 16/04/2023.
//

import Foundation
import UIKit

public class IntroductionViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        let config: UIImage.SymbolConfiguration
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.systemFont(ofSize: 48, weight: .bold, design: .rounded)
            label.heightAnchor.constraint(equalToConstant: 60).isActive = true
        } else {
            label.font = UIFont.systemFont(ofSize: 21, weight: .bold, design: .rounded)
            label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        label.adjustsFontSizeToFitWidth = true
        label.text = "Flag Semaphores"
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(pointSize: 90, weight: .regular)
        let image = UIImage(systemName: "flag.filled.and.flag.crossed", withConfiguration: config)
        imageView.image = image
        return imageView
    }()
    
    let copyrightLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular, design: .rounded)
        label.text = "Made by Amelia While for the Swift Student Challenge 2023"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    let modeStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 25
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    class ActionButton: UIButton {

        static func create(image: String, text: String) -> UIButton {
            var configuration = UIButton.Configuration.plain()
            configuration.title = text
            configuration.imagePlacement = .top
            configuration.imagePadding = 25
            let config: UIImage.SymbolConfiguration
            if UIDevice.current.userInterfaceIdiom == .pad {
                config = UIImage.SymbolConfiguration(pointSize: 90, weight: .regular)
            } else {
                config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
            }
            configuration.image = UIImage(systemName: image, withConfiguration: config)
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            
            button.imageView?.contentMode = .scaleAspectFit
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            button.tintColor = .tintColor
            button.setTitleColor(.tintColor, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15.5, weight: .regular)
            button.layer.masksToBounds = true
            button.layer.cornerCurve = .continuous
            button.layer.cornerRadius = 12.5
            
            return button
        }

        required init?(coder: NSCoder) {
            fatalError()
        }
        
    }
    
    lazy var learnMode: UIButton = {
        let button = ActionButton.create(image: "book.fill", text: "Learn")
        button.addTarget(self, action: #selector(transitionToLearn), for: .touchUpInside)
        return button
    }()
    
    lazy var challengeMode: UIButton = {
        let button = ActionButton.create(image: "flag.and.flag.filled.crossed", text: "Challenge")
        button.addTarget(self, action: #selector(transitionToChallenge), for: .touchUpInside)
        return button
    }()
    
    let wikipediaNotice: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Information on Flag Semaphores obtained from Wikipedia. Primary Source: Royal Navy Communications Branch Museum/Library.\nImage Credit: By No machine-readable author provided. Denelson83 assumed (based on copyright claims). - No machine-readable source provided. Own work assumed (based on copyright claims)., CC BY-SA 3.0, https://commons.wikimedia.org"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular, design: .rounded)
        label.textColor = .label
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let secondaryImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "AmyIRL")
        return imageView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(copyrightLabel)
        
        view.addSubview(modeStackView)
        modeStackView.addArrangedSubview(secondaryImageView)
        modeStackView.addArrangedSubview(learnMode)
        modeStackView.addArrangedSubview(challengeMode)
    
        view.addSubview(wikipediaNotice)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 17.5),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            wikipediaNotice.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            wikipediaNotice.widthAnchor.constraint(equalTo: titleLabel.widthAnchor, multiplier: 0.8),
            wikipediaNotice.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            wikipediaNotice.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13),
            
            modeStackView.topAnchor.constraint(equalTo: wikipediaNotice.bottomAnchor, constant: 15),
            modeStackView.leadingAnchor.constraint(equalTo: wikipediaNotice.leadingAnchor),
            modeStackView.trailingAnchor.constraint(equalTo: wikipediaNotice.trailingAnchor),

            copyrightLabel.topAnchor.constraint(equalTo: modeStackView.bottomAnchor, constant: 20),
            copyrightLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            copyrightLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            copyrightLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.025),
            copyrightLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25)
        ])
    }
    
    @objc private func transitionToChallenge() {
        self.transition(mode: .game)
    }
    
    @objc private func transitionToLearn() {
        self.transition(mode: .learn)
    }
    
    private func transition(mode: ProgramMode) {
        let viewController = CameraViewController(mode: mode)
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension IntroductionViewController: CameraViewControllerDelegate {
    
    public func didComplete(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
}
