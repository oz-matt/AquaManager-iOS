//
//  AQAddDeviceViewController.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField

protocol AQAddDeviceDelegate {
    func deviceAdded(device: AQDevice)
}

class AQAddDeviceViewController: AQBaseViewController, UITextFieldDelegate {
    
    enum AddState {
        case fillData
        case setName
    }
    
    @IBOutlet weak var dialogHeight: NSLayoutConstraint!
    @IBOutlet weak var headerLabel: UILabel!
    var delegate: AQAddDeviceDelegate! = nil
    var deviceLayer: AQDevicesBusinessLayer = AQDevicesBusinessLayer()
    var device: AQDevice?
    var currentState: AQAddDeviceViewController.AddState = .fillData
    
    @IBOutlet weak var passcodeTextField: JVFloatLabeledTextField!
    @IBOutlet weak var aquaIdTextField: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passcodeTextField.delegate = self
        aquaIdTextField.delegate = self
        passcodeTextField.returnKeyType = .done
        aquaIdTextField.returnKeyType = .done
        
        aquaIdTextField.setUpdatePlaceholderColor()
        passcodeTextField.setUpdatePlaceholderColor()
        
        aquaIdTextField.text = "8DC8B056"
        passcodeTextField.text  = "849DEEE4"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        if currentState == .fillData {
            self.dismiss(animated: true, completion: nil)
        }
        if currentState == .setName {
            if let aquaId = self.device!.getAquaId() {
               AQDevice.removeDevice(deviceId: aquaId)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    @IBAction func handleSubmitButton(_ sender: UIButton) {
        if currentState == .fillData {
            handleFillData()
        }
        if currentState == .setName {
            handleSetName()
        }
    }
    
    func handleFillData() {
        if validateFields() {
            self.showLoadingHUD()
            deviceLayer.registerDevice(aquaId: aquaIdTextField.text!, passcode: passcodeTextField.text!, completion: { (device, success) in
                self.hideHUD()
                if success && device != nil {
                    self.updateState()
                    self.device = device
                }
                else {
                    self.showAlertWithTitle("Error", message: "Bad device information")
                }
            })
        }
    }
    
    func handleSetName() {
        if aquaIdTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill name")
        }
        else {
            if validateDeviceName() {
                device!.name = aquaIdTextField.text!
                AQDevice.updateDevice(device: device!)
                self.delegate.deviceAdded(device: self.device!)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func updateState() {
        currentState = .setName
        DispatchQueue.main.async {
            self.headerLabel.text = "Name Your Device"
            self.aquaIdTextField.placeholder = "My Aqua"
            self.aquaIdTextField.text = ""
            self.aquaIdTextField.autocapitalizationType = UITextAutocapitalizationType.none
        }
        self.passcodeTextField.isHidden = true
        self.dialogHeight.constant = 180
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
        
    }
    
    func validateDeviceName() -> Bool {
        if !AQDevice.ifDeviceNameExists(name: aquaIdTextField.text!) {
           return true
        }
        else {
            self.showAlertWithTitle("Error", message: "Device with this name already exists")
            return false
        }
    }
    
    func validateFields() -> Bool {
        if passcodeTextField.text!.blank && aquaIdTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill all fields")
            return false
        }
        
        if aquaIdTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill Aqua ID")
            return false
        }
        
        if passcodeTextField.text!.blank {
            self.showAlertWithTitle("Error", message: "Please fill Passcode")
            return false
        }
        
        if AQDevice.ifDeviceExists(deviceId: aquaIdTextField.text!) {
           self.showAlertWithTitle("Error", message: "Device already exists")
           return false
        }
        
        return true
    }
}
