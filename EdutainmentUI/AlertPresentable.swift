//
//  AlertPresentable.swift
//  EdutainmentUI
//
//  Created by Damie on 12.10.2022.
//

import Foundation
import UIKit

protocol AlertPresentable {
    func presentAlert(title: String, message: String, buttonTitle: String)
}

extension AlertPresentable where Self: UIViewController {
    func presentAlert(title: String,
                      message: String,
                      buttonTitle: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let alertAction = UIAlertAction(
            title: buttonTitle,
            style: .default,
            handler: { _ in
            debugPrint("Alert occured. Title: \(title), and msg: \(message)")
        })
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
}
