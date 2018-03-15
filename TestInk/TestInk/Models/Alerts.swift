//
//  Alerts.swift
//  TestInk
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class Alert {
    public static func create(withTitle title: String?, andMessage message: String?, withPreferredStyle preferredStyle: UIAlertControllerStyle) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    public static func addAction(withTitle title: String?, style: UIAlertActionStyle, andHandler handler: ((UIAlertAction) -> Void)?, to alert: UIAlertController) {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        
        alert.addAction(alertAction)
    }
    public static func createErrorAlert(withMessage message: String) -> UIAlertController {
        let alertController = Alert.create(withTitle: "Error", andMessage: message, withPreferredStyle: .alert)
        Alert.addAction(withTitle: "OK", style: .default, andHandler: { (_) in
            return
        }, to: alertController)
        return alertController
    }
}
