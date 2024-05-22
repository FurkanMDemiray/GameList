//
//  GradientExtension.swift
//  GameList
//
//  Created by Melik Demiray on 23.05.2024.
//

import Foundation
import UIKit

extension UIView {
    func addGradient() {
        let colorTop = UIColor(hex: "#000000")
        let colorBottom = UIColor(hex: "#2D3436") // Night Club gradient

        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        // Add the gradient layer as a sublayer to the background view
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
