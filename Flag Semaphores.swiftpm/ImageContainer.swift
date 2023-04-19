//
//  ImageContainer.swift
//  demoapp
//
//  Created by Amy While on 18/04/2023.
//

import UIKit

class ImageContainer: UIView {
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let backgroundBlur: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        let blurEffect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = imageView.bounds
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(effectView)
        return imageView
    }()
    
    public var image: UIImage? {
        didSet {
            mainImageView.image = image
            backgroundBlur.image = image
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(backgroundBlur)
        addSubview(mainImageView)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            backgroundBlur.topAnchor.constraint(equalTo: topAnchor),
            backgroundBlur.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBlur.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBlur.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
