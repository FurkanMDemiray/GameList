//
//  AlertExtension.swift
//  GameList
//
//  Created by Melik Demiray on 20.05.2024.
//

import Foundation
import UIKit

extension UIViewController {

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
