//
//  AlertView.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-07.
//

import Foundation
import UIKit

class AlertController {
    static func displayAlert(message: String, parentView: UIViewController) {
        let alert = UIAlertController(title: "oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        parentView.present(alert, animated: true, completion: nil)
    }
}


