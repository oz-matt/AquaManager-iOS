//
//  AQDevicesViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps

class AQDeviceCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblBatt: UILabel!
    @IBOutlet weak var btnSetup: UIButton!
}

class AQDevicesViewController: AQBaseViewController, UITableViewDelegate, UITableViewDataSource, AQAddDeviceDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDeviceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(AQDevicesViewController.fullRefresh), name: Notification.Name.refreshDevices, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDeviceList()
    }
    
    func fullRefresh() {
        self.showLoadingHUD()
        updateDeviceList()
        self.hideHUD()
    }
    
    func updateDeviceList() {
        AQDeviceManager.manager.reloadDevices()
        tableView.reloadData()
    }
    
    @IBAction func handleAddDeviceButton(_ sender: UIButton) {
        if !isInternetAvailable() {
            return
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQAddDeviceViewController") as! AQAddDeviceViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleSetupDeviceButton(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "Device Settings", message: "Options to select", preferredStyle: .actionSheet)
        let device = AQDeviceManager.manager.devices[sender.tag]
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        let infoActionButton = UIAlertAction(title: "Information", style: .default) { action -> Void in
            self.showDeviceInfor(device: device)
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(infoActionButton)
        let rawActionButton = UIAlertAction(title: "Raw Data", style: .default) { action -> Void in
            self.showDeviceRawData(device: device)
        }
        actionSheetController.addAction(rawActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Remove", style: .destructive) { action -> Void in
            self.removeDevice(device: device)
        }
        actionSheetController.addAction(deleteActionButton)
        if AQManager.manager.isIpad() {
             actionSheetController.showInView(view: sender)
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func removeDevice(device: AQDevice) {
        var message = "Do you really want to remove this device?"
        if device.name != nil {
            message = "Do you really want to remove this device '\(device.name!)'?"
        }
        
        let alert = UIAlertController(title: "Remove Device", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
            self.showLoadingHUD()
            AQDeviceManager.manager.removeDevice(device: device)
            self.tableView.reloadData()
            self.hideHUD()
            NotificationCenter.default.post(Notification(name: Notification.Name.showToastMessage, object: nil, userInfo: ["text": "Device removed."]))
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDeviceInfor(device: AQDevice) {
        let vc = AQControllerFactory.factory.getDeviceInfoController()
        vc.device = device
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showDeviceRawData(device: AQDevice) {
        let vc = AQControllerFactory.factory.getRawDataList(device: device)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AQDeviceManager.manager.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQDeviceCell") as! AQDeviceCell
        let device = AQDeviceManager.manager.devices[indexPath.row]
        cell.lblName.text = device.getName()
        cell.btnSetup.tag = indexPath.row
        cell.lblLocation.text = "Loading..."
        AQUtils.getLocationStringShort(location: device.getLocation(index: 0), completion: { (result) in
            cell.lblLocation.text = result
        })
        
        cell.lblBatt.text = device.getBatt()
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = self.defineColorOfCell(device: device)
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AQControllerFactory.factory.getMainMapController()
        let dev = AQDeviceManager.manager.devices[indexPath.row]
        vc.devicesList = [dev]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AQDeviceManager.manager.devices.count == 0 {
            return 75
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AQDeviceManager.manager.devices.count == 0 {
            let label = UILabel(frame: CGRect(x: 16, y: 16, width: self.view.frame.size.width - 32, height: 75))
            label.text = "No Devices"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            label.font = UIFont(name: AQFonts.FONT_REGULAR, size: 15)
            return label
 
        }
        return nil
    }
    
    func deviceAdded(device: AQDevice) {
        NotificationCenter.default.post(Notification(name: Notification.Name.showToastMessage, object: nil, userInfo: ["text": "Device added."]))
        updateDeviceList()
    }
    
    func defineColorOfCell(device: AQDevice) -> UIColor {
        if let aqsens = device.getActiveSens(index: 0) {
           let time = aqsens.getDate()
            if let rate = aqsens.sensorsData?.updateRate {
               let orangeThreshold = rate * 60 * 3
               let redThrehold = rate * 60 * 6
                
               let interval = -time.timeIntervalSinceNow
               print("int \(interval)")
               print("red \(redThrehold)")
               print("orange \(orangeThreshold)")
                
                if interval > Double(redThrehold) {
                    return AQColor.DEVICE_ROW_COLOR_RED
                }
                if interval > Double(orangeThreshold) {
                    return AQColor.DEVICE_ROW_COLOR_ORANGE
                }
                return AQColor.DEVICE_ROW_COLOR_GREEN
            }
        }
        return UIColor.lightGray
    }
}
