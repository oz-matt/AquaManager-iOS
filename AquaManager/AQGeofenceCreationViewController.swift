//
//  AQGeofenceCreationViewController.swift
//  AquaManager
//
//  Created by Anton on 2/9/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import JVFloatLabeledTextField

class AQTempGeofence {
    var name: String! = ""
    var radius: Float! = 0
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var isCircle: Bool = false
}


protocol AQGeofenceCreationDelegate {
    func createGeofence(geofence: AQTempGeofence)
}

class AQGeofenceCreationViewController: AQBaseViewController, UITextFieldDelegate {
    @IBOutlet weak var geofenceNameTextField: JVFloatLabeledTextField!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var segmentSize: UISegmentedControl!
    @IBOutlet weak var radiusTextField: JVFloatLabeledTextField!

    var centerCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var delegate: AQGeofenceCreationDelegate! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.radiusTextField.delegate = self
        self.radiusTextField.returnKeyType = .done
        self.geofenceNameTextField.returnKeyType = .done
        self.radiusTextField.setUpdatePlaceholderColor()
        self.geofenceNameTextField.setUpdatePlaceholderColor()
    }
    
    @IBAction func handleConfirmButton(_ sender: UIButton) {
        if validateFields() {
            let tempGeofence = AQTempGeofence()
            tempGeofence.name = geofenceNameTextField.text!
            tempGeofence.radius = Float(radiusTextField.text!)!
            tempGeofence.isCircle = segmentSize.selectedSegmentIndex == 0
            tempGeofence.coordinate = self.centerCoordinate

            self.delegate.createGeofence(geofence: tempGeofence)
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateFields() -> Bool {
        if radiusTextField.text!.blank && geofenceNameTextField.text!.blank {
           self.showAlertWithTitle("Error", message: "Please fill all fields")
           return false
        }
        
        if geofenceNameTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill name")
            return false
        }
        
        if AQGeofence.ifGeofenceExists(name: geofenceNameTextField.text!) {
            self.showAlertWithTitle("Error", message: "Geofence with this name already exists")
            return false
        }
        
        if radiusTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill radius")
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if newString.characters.count > 0 {
            
            // Find out whether the new string is numeric by using an NSScanner.
            // The scanDecimal method is invoked with NULL as value to simply scan
            // past a decimal integer representation.
            let scanner: Scanner = Scanner(string:newString)
            let isNumeric = scanner.scanDecimal(nil) && scanner.isAtEnd
            
            return isNumeric
            
        } else {
            
            // To allow for an empty text field
            return true
        }
    }
    
}
