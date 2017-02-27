//
//  AQFillNotificationInfoController.swift
//  AquaManager
//
//  Created by Anton on 2/15/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField

enum FillMode {
    case number
    case email
    case mac
}

protocol AQFillNotificationDelegate {
    func emailEntered(string: String)
    func numberEntered(string: String)
    func macAddressEntered(string: String)
}

class AQFillNotificationInfoController: AQBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: JVFloatLabeledTextField!
    @IBOutlet weak var lblHeader: UILabel!

    var mode: FillMode = .number
    var delegate: AQFillNotificationDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == .number {
            self.lblHeader.text = "Enter Phone Number"
            self.textField.placeholder = "Phone number"
            self.textField.keyboardType = .phonePad
        }
        if mode == .email {
            self.lblHeader.text = "Enter Email"
            self.textField.placeholder = "Email"
            self.textField.autocapitalizationType = .none
        }
        if mode == .mac {
            self.lblHeader.text = "Enter Mac Address"
            self.textField.placeholder = "Mac Address"
            self.textField.autocapitalizationType = .allCharacters
        }
        self.textField.delegate = self
        self.textField.returnKeyType = .done
        self.textField.setUpdatePlaceholderColor()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if mode == .number {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            
            if newString.characters.count > 0 {
                
                // Find out whether the new string is numeric by using an NSScanner.
                // The scanDecimal method is invoked with NULL as value to simply scan
                // past a decimal integer representation.
                let scanner: Scanner = Scanner(string:newString)
                let isNumeric = scanner.scanUnsignedLongLong(nil) && scanner.isAtEnd
                
                return isNumeric
                
            } else {
                
                // To allow for an empty text field
                return true
            }
        }
        
        if mode == .email {
            return true
        }
        
        if mode == .mac {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if string.blank {
                return true
            }
            
            var final = newString.replacingOccurrences(of: ":", with: "")
            if final.characters.count > 12 {
               return false
            }
            var symbolsOnly = newString.replacingOccurrences(of: ":", with: "")
            for i in 0..<symbolsOnly.characters.count {
                if i == 1 {
                    final.insert(":", at: final.index(final.startIndex, offsetBy: 2))
                }
                if i == 3 {
                    final.insert(":", at: final.index(final.startIndex, offsetBy: 5))
                }
                if i == 5 {
                    final.insert(":", at: final.index(final.startIndex, offsetBy: 8))
                }
                if i == 7 {
                    final.insert(":", at: final.index(final.startIndex, offsetBy: 11))
                }
                if i == 9 {
                    final.insert(":", at: final.index(final.startIndex, offsetBy: 14))
                }
            }
            textField.text = final
            return false
        }
        
        return true
    }
    
    @IBAction func handleSubmitButton(_ sender: UIButton) {
        if mode == .number {
            if validateNumber() {
                delegate.numberEntered(string: textField.text!)
                self.dismiss(animated: true, completion: nil)
            }
        }
        if mode == .email {
            if validateEmail() {
                delegate.emailEntered(string: textField.text!)
                self.dismiss(animated: true, completion: nil)
            }
        }
        if mode == .mac {
            if validateMac() {
                delegate.macAddressEntered(string: textField.text!)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateEmail() -> Bool {
        let value = textField.text!
        
        if value.blank {
           self.showCustomAlert("Error", text: "Please enter email")
            return false
        }
        
        let regex = try! NSRegularExpression(pattern: "^[\\w!#$%&'*+/=?`{|}~^-]+(?:\\.[\\w!#$%&'*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$", options: [])
        if regex.firstMatch(in: value, options: [], range: NSMakeRange(0, value.characters.count)) != nil {
            return true
        }
        self.showCustomAlert("Error", text: "Please enter valid email")
        return false
    }
    
    func validateMac() -> Bool {
        let value = textField.text!
        
        if value.blank {
            self.showCustomAlert("Error", text: "Please enter Mac Address")
            return false
        }
        let regex = try! NSRegularExpression(pattern: "^([0-9A-F]{2}[:-]){5}([0-9A-F]{2})$", options: [])
        if regex.firstMatch(in: value, options: [], range: NSMakeRange(0, value.characters.count)) != nil {
            return true
        }
        self.showCustomAlert("Error", text: "Please enter valid MAC")
        return false
    }
    
    func validateNumber() -> Bool {
        let value = textField.text!
        if value.blank {
            self.showCustomAlert("Error", text: "Please enter phone number")
            return false
        }
        
        let regex = try! NSRegularExpression(pattern: ".*[^0-9()-].*", options: [])
        if regex.firstMatch(in: value, options: [], range: NSMakeRange(0, value.characters.count)) != nil {
            return false
        }
        return true
    }
    

}
