//
//  FadingLabel.swift
//  demoapp
//
//  Created by Amy While on 18/04/2023.
//

import UIKit

class FadingLabel: UILabel {

    func set(text: String, animate: Bool) {
        if !animate {
            self.text = text
            layer.opacity = 1.0
            return
        }
        func showNewText() {
            self.text = text
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let self else {
                    return
                }
                layer.opacity = 1
            }
        }
        if layer.opacity != 0 {
            UIView.animate(withDuration: 0.15) { [weak self] in
                guard let self else {
                    return
                }
                layer.opacity = 0
            } completion: { _ in
                showNewText()
            }
        } else {
            showNewText()
        }
    }
    
}
