//
//  AQSettingsViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQSettingTimeZoneCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var zoneLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
}

class AQSettingsTextFieldCell: UITableViewCell {
    
    @IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var textField: UITextField!
}

class AQSettingLabelCell: UITableViewCell {
    
    @IBOutlet weak var labelSub: UILabel!
    @IBOutlet weak var labelMain: UILabel!
}

class AQSettingSwitchCell: UITableViewCell {
    @IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
}
class AQSettingButtonCell: UITableViewCell {
    @IBOutlet weak var labelMain: UILabel!
    @IBOutlet weak var btnAction: UIButton!
    
}

class AQSettingsViewController: AQBaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let SWITCH_GEOFENCE = 0
    let SWITCH_INTRO = 1
    
    var mapType: MapTypes = MapTypes.normal
    var markersCount: Int = 0
    var showGeofences: Bool = true
    var showIntro: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapType = AQSettingsManager.manager.getMapType()
        markersCount = AQSettingsManager.manager.getNumberOfMarkers()
        showGeofences = AQSettingsManager.manager.getShowGeofences()
        showIntro = AQSettingsManager.manager.getShowIntro()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.title = "Settings"

        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(AQSettingsViewController.handleSave))
    }
    
    @IBAction func handleSaveButton(_ sender: UIButton) {
        self.handleSave()
    }
    
    @IBAction func handleCancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleSave() {
        self.view.endEditing(true)
        self.showLoadingHUD()
        AQSettingsManager.manager.setMapType(mapType: mapType)
        AQSettingsManager.manager.setNumberOfMarkers(number: markersCount)
        AQSettingsManager.manager.setShowIntro(bool: showIntro)
        AQSettingsManager.manager.setShowGeofences(bool: showGeofences)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleButtonAction(_ sender: UIButton) {
        let vc = AQControllerFactory.factory.getRemoveNotificationViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleSwitchChange(_ sender: UISwitch) {
        if sender.tag == SWITCH_INTRO {
            showIntro = sender.isOn
        }
        if sender.tag == SWITCH_GEOFENCE {
            showGeofences = sender.isOn
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQSettingTimeZoneCell") as! AQSettingTimeZoneCell
            cell.mainLabel.text = "Timezone"
            let tZone = TimeZone.current
            cell.zoneLabel.text = tZone.localizedName(for: .generic, locale: Locale.current)
            cell.timeLabel.text = tZone.abbreviation()
            cell.selectionStyle = .none
            return cell
            
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQSettingLabelCell") as! AQSettingLabelCell
            cell.labelMain.text = "MainMap display"
            cell.labelSub.text = mapType.rawValue
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQSettingsTextFieldCell") as! AQSettingsTextFieldCell
            cell.labelMain.text = "Max No. Markers Per Device"
            cell.textField.text = "\(markersCount)"
            cell.textField.delegate = self
            cell.textField.returnKeyType = .done
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQSettingSwitchCell") as! AQSettingSwitchCell
            cell.labelMain.text = "Show Geofences On Map"
            cell.switchButton.isOn = showGeofences
            cell.switchButton.tag = SWITCH_GEOFENCE
            cell.selectionStyle = .none
            return cell
            
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQSettingSwitchCell") as! AQSettingSwitchCell
            cell.labelMain.text = "Show Launch Screen At Start"
            cell.switchButton.isOn = showIntro
            cell.switchButton.tag = SWITCH_INTRO
            cell.selectionStyle = .none
            return cell
            
        }
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQSettingButtonCell") as! AQSettingButtonCell
            cell.labelMain.text = "Remove Notification From ID"
            cell.btnAction.setTitle("ENTER ID", for: .normal)
            cell.selectionStyle = .none
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let cell = tableView.cellForRow(at: indexPath) as! AQSettingLabelCell
           showMapTypeSelector(view: cell.labelSub)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if UInt(string) != nil || string.blank {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if UInt(textField.text!) != nil {
            self.markersCount = Int(UInt(textField.text!)!)
        }
        else {
           self.markersCount = 50
            textField.text = "50"
        }
        
    }
    
    func showMapTypeSelector(view: UIView) {
        let actionSheetController = UIAlertController(title: "Map Display", message: "Options to select", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        let normalActionButton = UIAlertAction(title: "Normal", style: .default) { action -> Void in
            self.mapType = .normal
            self.tableView.reloadData()
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(normalActionButton)
        let satteliteActionButton = UIAlertAction(title: "Satellite", style: .default) { action -> Void in
            self.mapType = .sattelite
            self.tableView.reloadData()
        }
        actionSheetController.addAction(satteliteActionButton)
        
        let hybridActionButton = UIAlertAction(title: "Hybrid", style: .default) { action -> Void in
            self.mapType = .hybrid
            self.tableView.reloadData()
        }
        actionSheetController.addAction(hybridActionButton)
        let terrainActionButton = UIAlertAction(title: "Terrain", style: .default) { action -> Void in
            self.mapType = .terrain
            self.tableView.reloadData()
        }
        actionSheetController.addAction(terrainActionButton)
        if AQManager.manager.isIpad() {
           actionSheetController.showInView(view: view)
        }
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
}
