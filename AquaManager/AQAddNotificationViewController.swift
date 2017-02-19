//
//  AQAddNotificationViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

enum AlarmType: String {
    case textMessage = "text"
    case email = "email"
    case unknown = "unknown"
}

class AQTempNotification {
    var device: AQDevice?
    var geofence: AQGeofence?
    var trigger: AQTrigger = .unknown
    var alarm: AlarmType = .unknown
    var continuous: Bool = true
    var target: String?
    var macAdress: String?
    var notId: String?
}

protocol AQAddNotificationDelegate {
    func createNewNotification(temp: AQTempNotification)
}

class AQAddNotificationViewController: AQBaseViewController, AQFilterListDelegate, AQFillNotificationDelegate {
    
    @IBOutlet weak var lblNotifiactionDesc: UILabel!
    @IBOutlet weak var changeSwitch: UISwitch!
    @IBOutlet weak var contSwitch: UISwitch!
    @IBOutlet weak var btnAlarm: UIButton!
    @IBOutlet weak var btnTrigger: UIButton!
    @IBOutlet weak var btnDevice: UIButton!

    var tempNotification: AQTempNotification = AQTempNotification()
    var delegate: AQAddNotificationDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempNotification = AQTempNotification()
        btnAlarm.setTitle("Select", for: .normal)
        btnTrigger.setTitle("Select", for: .normal)
        btnDevice.setTitle("Select", for: .normal)
        contSwitch.isOn = true
        changeSwitch.isOn = false
    }
    
    @IBAction func handleDeviceButton(_ sender: UIButton) {
        showFilterScreenDevices()
    }
    
    func showFilterScreenDevices() {
        let vc = AQControllerFactory.factory.getFilterListViewController()
        vc.delegate = self
        vc.selectedDevices = [AQDevice]()
        vc.filterMode = .devices
        vc.selectMode = .single
        let nav = AQControllerFactory.factory.getNavigationControllerWithRoot(vc: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func showFilterScreenGeofences() {
        let vc = AQControllerFactory.factory.getFilterListViewController()
        vc.delegate = self
        vc.filterMode = .geofences
        vc.selectMode = .single
        let nav = AQControllerFactory.factory.getNavigationControllerWithRoot(vc: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func updatedData(devices: [AQDevice], geofences: [AQGeofence]) {
        if devices.count > 0 {
            tempNotification.device = devices.first!
            DispatchQueue.main.async {
                self.btnDevice.setTitle(self.tempNotification.device!.getName(), for: .normal)
            }
            self.updateInfo()
        }
        if geofences.count > 0 {
            tempNotification.geofence = geofences.first!
            DispatchQueue.main.async {
                if self.tempNotification.trigger == .enterGeofence {
                    self.btnTrigger.setTitle("Enters \(self.tempNotification.geofence!.getName())", for: .normal)
                }
                if self.tempNotification.trigger == .exitGeofence {
                    self.btnTrigger.setTitle("Exits \(self.tempNotification.geofence!.getName())", for: .normal)
                }
            }
            self.updateInfo()
        }
    }
    
    func updateTriggerButton(string: String) {
        DispatchQueue.main.async {
            self.btnTrigger.setTitle(string, for: .normal)
        }
    }
    
    @IBAction func handleTriggerButton(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "Trigger", message: "Options to select", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        var actionButton = UIAlertAction(title: "Low Battery", style: .default) { action -> Void in
            self.tempNotification.trigger = .lowBattery
            self.updateTriggerButton(string: "Low Battery")
            self.updateInfo()
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Enters Geofence", style: .default) { action -> Void in
            if AQGeofenceManager.manager.geofences.count > 0 {
               self.tempNotification.trigger = .enterGeofence
               self.showFilterScreenGeofences()
            }
            else {
               self.showCustomAlert("Warning", text: "Create at least one geofence to use this function")
            }
            
        }
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Exits Geofence", style: .default) { action -> Void in
            if AQGeofenceManager.manager.geofences.count > 0 {
                self.tempNotification.trigger = .exitGeofence
                self.showFilterScreenGeofences()
            }
            else {
                self.showCustomAlert("Warning", text: "Create at least one geofence to use this function")
            }
        }
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Uploads Data", style: .default) { action -> Void in
            self.tempNotification.trigger = .uploadsData
            self.updateTriggerButton(string: "Uploads Data")
            self.updateInfo()
        }
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Sees Mac Address", style: .default) { action -> Void in
            let vc = AQControllerFactory.factory.getFillNotificationInfoController()
            vc.mode = .mac
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Starts Moving", style: .default) { action -> Void in
            self.tempNotification.trigger = .startMoving
            self.updateTriggerButton(string: "Starts Moving")
            self.updateInfo()
        }
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Stops Moving", style: .default) { action -> Void in
            self.tempNotification.trigger = .stopsMoving
            self.updateTriggerButton(string: "Stops Moving")
            self.updateInfo()
        }
        actionSheetController.addAction(actionButton)
        
        if AQManager.manager.isIpad() {
            actionSheetController.showInView(view: sender)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func updateInfo() {
        var string = "Whenever"
        if tempNotification.device != nil && tempNotification.device!.getName() != nil {
            string += " \(tempNotification.device!.getName()!)"
        }
        else {
            string += " <?>"
        }
        string += "\(self.getProperTrigger()), \(self.getProperAlarm())"
        
        DispatchQueue.main.async {
            self.lblNotifiactionDesc.text = string
        }
    }
    
    func getProperAlarm() -> String {
        if tempNotification.alarm == .unknown {
            return "send <?> a <?>"
        }
        if tempNotification.alarm == .email {
            return "send \(tempNotification.target!) a e-mail"
        }
        if tempNotification.alarm == .textMessage {
            return "send \(tempNotification.target!) a text"
        }
        return "send <?> a <?>"
    }
    
    func getProperTrigger() -> String {
        if tempNotification.trigger == .unknown {
            return "<?>"
        }
        if tempNotification.trigger == .lowBattery {
            if tempNotification.continuous {
               return "'s battery is low"
            }
            else {
               return "'s battery changes to low"
            }
        }
        if tempNotification.trigger == .enterGeofence {
            if tempNotification.continuous {
                return " is inside '\(tempNotification.geofence!.getName())'"
            }
            else {
                return " enters '\(tempNotification.geofence!.getName())'"
            }
            
        }
        if tempNotification.trigger == .exitGeofence {
            if tempNotification.continuous {
                return " is outside '\(tempNotification.geofence!.getName())'"
            }
            else {
                return " exits '\(tempNotification.geofence!.getName())'"
            }
        }
        if tempNotification.trigger == .uploadsData {
            return " uploads data"
        }
        if tempNotification.trigger == .seesMac {
            if tempNotification.continuous {
                return " can see \(tempNotification.macAdress!)"
            }
            else {
                return " gains sight of \(tempNotification.macAdress!)"
            }
            
        }
        if tempNotification.trigger == .startMoving {
            if tempNotification.continuous {
                return " moves"
            }
            else {
                return " begins moving"
            }
            
        }
        if tempNotification.trigger == .stopsMoving {
            if tempNotification.continuous {
                return " is stopped"
            }
            else {
                return " stops"
            }
            
        }
        
        return "<?>"
    }
    
    @IBAction func handleAlarmButton(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "Alarm type", message: "Options to select", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        var actionButton = UIAlertAction(title: "Text Message", style: .default) { action -> Void in
            let vc = AQControllerFactory.factory.getFillNotificationInfoController()
            vc.mode = .number
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(actionButton)
        
        actionButton = UIAlertAction(title: "Email", style: .default) { action -> Void in
            let vc = AQControllerFactory.factory.getFillNotificationInfoController()
            vc.mode = .email
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        actionSheetController.addAction(actionButton)
        if AQManager.manager.isIpad() {
            actionSheetController.showInView(view: sender)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func handleInfoOnChangeButton(_ sender: UIButton) {
        self.showCustomAlert("On Change", text: "This option will set the notification to only send an alarm when the target Aqua changes from a non-triggered state to a triggered one.")
    }
    
    @IBAction func handleSubmitButton(_ sender: UIButton) {
        if validateNotification() {
           self.tempNotification.notId = AQNotificationsManager.manager.getUniqueId()
           self.delegate.createNewNotification(temp: self.tempNotification)
           self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func validateNotification() -> Bool {
        if tempNotification.device == nil {
            self.showCustomAlert("Error", text: "Please choose device")
            return false
        }
        if tempNotification.trigger == .unknown {
            self.showCustomAlert("Error", text: "Please select trigger option")
            return false
        }
        if tempNotification.alarm == .unknown {
            self.showCustomAlert("Error", text: "Please select alarm type")
            return false
        }

        return true
    }
    
    @IBAction func handleContinueTrigger(_ sender: UISwitch) {
        changeSwitch.isOn = !changeSwitch.isOn
        tempNotification.continuous = contSwitch.isOn
        self.updateInfo()
    }
    @IBAction func handleOnChangeTrigger(_ sender: UISwitch) {
        contSwitch.isOn = !contSwitch.isOn
        tempNotification.continuous = contSwitch.isOn
        self.updateInfo()
    }
    
    func emailEntered(string: String) {
        DispatchQueue.main.async {
            self.btnAlarm.setTitle(string, for: .normal)
        }
        self.tempNotification.alarm = .email
        self.tempNotification.target = string
        self.updateInfo()
    }
    
    func numberEntered(string: String) {
        DispatchQueue.main.async {
            self.btnAlarm.setTitle(string, for: .normal)
        }
        self.tempNotification.alarm = .textMessage
        self.tempNotification.target = string
        self.updateInfo()
    }
    
    func macAddressEntered(string: String) {
        DispatchQueue.main.async {
            self.btnTrigger.setTitle("sees \(string)", for: .normal)
        }
        self.tempNotification.macAdress = string
        self.tempNotification.trigger = .seesMac
        self.updateInfo()
    }
}
