//
//  AQGeofencesViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQGeofenceCell: UITableViewCell {
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
}

class AQGeofencesViewController: AQBaseViewController, UITableViewDelegate, UITableViewDataSource, AQAddGeofenceDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var geofences: [AQGeofence] = [AQGeofence]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.refreshList()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geofences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQGeofenceCell") as! AQGeofenceCell
        let geo = geofences[indexPath.row]
        cell.btnSetting.tag = indexPath.row
        cell.nameLabel.text = geo.getName()
        cell.sizeLabel.text = "\(geo.getSize()) mi\u{00B2}"
        AQUtils.getLocationStringShort(location: geo.getLocation()) { (result) in
            cell.centerLabel.text = result
        }
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func handleAddButton(_ sender: UIButton) {
        let vc = AQControllerFactory.factory.getAddGeofenceController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleSettingButton(_ sender: UIButton) {
        let actionSheetController = UIAlertController(title: "Geofence Settings", message: "Options to select", preferredStyle: .actionSheet)
        let geofence = geofences[sender.tag]
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        let deleteActionButton = UIAlertAction(title: "Remove", style: .destructive) { action -> Void in
            self.removeGeofence(geofence: geofence)
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(deleteActionButton)
        if AQManager.manager.isIpad() {
            actionSheetController.showInView(view: sender)
        }
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func removeGeofence(geofence: AQGeofence) {
        var message = "Do you really want to remove this Geofence?"
        if !geofence.getName().blank {
            message = "Do you really want to remove this Geofence '\(geofence.getName())'?"
        }
        
        let alert = UIAlertController(title: "Remove Geofence", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (action) in
            self.showLoadingHUD()
            AQGeofence.removeGeofence(geofence: geofence)
            self.refreshList()
            self.hideHUD()
            NotificationCenter.default.post(Notification(name: Notification.Name.showToastMessage, object: nil, userInfo: ["text": "Geofence removed."]))
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if geofences.count == 0 {
            return 75
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AQControllerFactory.factory.getMainMapController()
        let geo = AQGeofenceManager.manager.geofences[indexPath.row]
        vc.geofencesList = [geo]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if geofences.count == 0 {
            let label = UILabel(frame: CGRect(x: 16, y: 16, width: self.view.frame.size.width - 32, height: 75))
            label.text = "No Geofences"
            label.numberOfLines = 0
            label.textAlignment = .center
            label.textColor = UIColor.lightGray
            label.font = UIFont(name: AQFonts.FONT_REGULAR, size: 15)
            return label
            
        }
        return nil
    }
    
    func refreshList() {
        AQGeofenceManager.manager.reloadGeofences()
        self.geofences = AQGeofenceManager.manager.geofences
        self.tableView.reloadData()
    }
}
