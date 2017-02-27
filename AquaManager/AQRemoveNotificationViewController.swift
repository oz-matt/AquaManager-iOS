//
//  AQRemoveNotificationViewController.swift
//  AquaManager
//
//  Created by Anton on 2/11/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField

class AQRemoveNotificationViewController: AQBaseViewController {
    
    @IBOutlet weak var deviceNameTextField: JVFloatLabeledTextField!
    @IBOutlet weak var notificatioIdTextField: JVFloatLabeledTextField!
    
    let layer = AQNotificationBusinessLayer()
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleOKButton(_ sender: UIButton) {
        if validateFields() {
            self.showLoadingHUD()
            layer.removeNotificationById(notId: notificatioIdTextField.text!, name: deviceNameTextField.text!, completion: { (result, success) in
                if !success {
                    self.showCustomAlert("Error", text: result)
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
                self.hideHUD()
            })
        }
    }
    
    func validateFields() -> Bool {
        if deviceNameTextField.text!.blank && notificatioIdTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill all fields")
            return false
        }
        
        if notificatioIdTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill Notification ID")
            return false
        }
        
        if deviceNameTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill Device Name")
            return false
        }
        
        return true
    }
}
