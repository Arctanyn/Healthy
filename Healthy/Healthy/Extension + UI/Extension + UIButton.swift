//
//  Extension + UIButton.swift
//  Healthy
//
//  Created by Малиль Дугулюбгов on 07.01.2022.
//

import UIKit

extension UIButton {
    func addSelectedEffect() {
        self.layer.shadowOpacity = 1
        self.layer.shadowColor = UIColor.systemIndigo.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func dentAnimation() {
        let dent = CASpringAnimation(keyPath: "transform.scale")
        dent.fromValue = 1
        dent.toValue = 0.96
        dent.duration = 0.2
        dent.autoreverses = false
        dent.initialVelocity = 0.5
        layer.add(dent, forKey: nil)
    }
}
