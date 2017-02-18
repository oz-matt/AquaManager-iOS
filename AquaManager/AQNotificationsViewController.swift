//
//  AQNotificationsViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQNotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblAlarm: UILabel!
    @IBOutlet weak var lblTrigger: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnSetting: UIButton!
    
    
}

class AQNotificationsViewController: AQBaseViewController, AQAddNotificationDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var layer: AQNotificationBusinessLayer = AQNotificationBusinessLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AQNotificationsManager.manager.reloadNotifications()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AQManager.manager.refreshAllData()
    }
    
    @IBAction func handleSettingButton(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "Notification Settings", message: "Options to select", preferredStyle: .actionSheet)
        let not = AQNotificationsManager.manager.notifications[sender.tag]
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        let infoActionButton = UIAlertAction(title: "Information", style: .default) { action -> Void in
            self.showNotificationInfo(not: not)
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(infoActionButton)

        let deleteActionButton = UIAlertAction(title: "Remove", style: .destructive) { action -> Void in
            self.showNotificationInfo(not: not)
        }
        actionSheetController.addAction(deleteActionButton)
        if AQManager.manager.isIpad() {
            actionSheetController.showInView(view: sender)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func handleAddButton(_ sender: UIButton) {
        if AQDeviceManager.manager.devices.count > 0 {
            let vc = AQControllerFactory.factory.getAddNotificationViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        else {
            self.showCustomAlert("Error", text: "To create notification you need at least one device")
        }
    }
    
    func createNewNotification(temp: AQTempNotification) {
        self.showLoadingHUD()
        if temp.trigger == .enterGeofence || temp.trigger == .exitGeofence {
            if temp.geofence?.isCircle == true {
               layer.insertNotificationSimpleGeofenceCircle(not: temp, completion: { (result, success) in
                    self.handleNotificationSuccess(result: result, temp: temp)
               })
            }
            else {
                layer.insertNotificationSimpleGeofencePolygon(not: temp, completion: { (result, success) in
                    self.handleNotificationSuccess(result: result, temp: temp)
                })
            }
        }
        else {
            layer.insertNotificationSimple(not: temp, completion: { (result, success) in
                self.handleNotificationSuccess(result: result, temp: temp)
            })
        }
    }
    
    func handleNotificationSuccess(result: String, temp: AQTempNotification) {
        self.hideHUD()
        if result == "Success" {
            let not = AQNotification.createNewNotification(temp: temp)
            AQNotificationsManager.manager.reloadNotifications()
            self.tableView.reloadData()
            return
        }
        if result == "Full" {
            self.showCustomAlert("Device Full", text: "The maximum number of notifications has been reached for this device. Some notifications must be deleted before more can be added.")
            return
        }
        self.showCustomAlert("Error", text: "Server error")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AQNotificationsManager.manager.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQNotificationTableViewCell") as! AQNotificationTableViewCell
        let not = AQNotificationsManager.manager.notifications[indexPath.row]
        cell.lblName.text = not.aquaname
        cell.btnSetting.tag = indexPath.row
        cell.lblAlarm.text = not.alert
        cell.lblTrigger.text = not.trigger

        cell.selectionStyle = .none
        return cell
    }
    
    func showNotificationInfo(not: AQNotification) {
        let vc = AQControllerFactory.factory.getNotificationInfoViewController()
        vc.not = not
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let not = AQNotificationsManager.manager.notifications[indexPath.row]
        self.showNotificationInfo(not: not)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AQNotificationsManager.manager.notifications.count == 0 {
            return 75
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if AQNotificationsManager.manager.notifications.count == 0 {
            let label = UILabel(frame: CGRect(x: 16, y: 16, width: self.view.frame.size.width - 32, height: 75))
            label.text = "No Notification"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            label.font = UIFont(name: AQFonts.FONT_REGULAR, size: 15)
            return label
            
        }
        return nil
    }

}
