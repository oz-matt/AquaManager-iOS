//
//  AQDeviceInfoViewController.swift
//  AquaManager
//
//  Created by Anton on 2/4/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQInfoSimpleCell: UITableViewCell {
    
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    func makeEmpty() {
        self.lblMain.text = ""
        self.lblSub.text = ""
    }
}

class AQInfoLocationCell: UITableViewCell {
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDate: UILabel!
}

class AQInfoDropDownCell: UITableViewCell {
    @IBOutlet weak var lblMain: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    
}

class AQDeviceInfoViewController: AQBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var device: AQDevice!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Device Info"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Name"
            cell.lblSub.text = device.getName()
           cell.selectionStyle = .none
           return cell
        }
        if indexPath.row == 1 {
           let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Device"
            cell.lblSub.text = device.getBatt()
           cell.selectionStyle = .none
           return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoLocationCell") as! AQInfoLocationCell
            cell.lblHeader.text = "Current Location"
            if device.aqsens != nil && device.aqsens!.count > 0 {
                let data = device.aqsens![0]
                cell.lblDate.text = AQUtils.getTitleDate(date: data.getDate())
            }
            cell.lblLocation.text = "Loading..."
            AQUtils.getLocationStringLong(location: device.getLocation(index: 0), completion: { (result) in
                cell.lblLocation.text = result
            })
            
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoLocationCell") as! AQInfoLocationCell
            cell.lblHeader.text = "Previous Location"
            if device.aqsens != nil && device.aqsens!.count > 1 {
                let data = device.aqsens![1]
                cell.lblDate.text = AQUtils.getTitleDate(date: data.getDate())
            }
            cell.lblLocation.text = "Loading..."
            AQUtils.getLocationStringLong(location: device.getLocation(index: 1), completion: { (result) in
                cell.lblLocation.text = result
            })
            
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.makeEmpty()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoDropDownCell") as! AQInfoDropDownCell
            cell.lblMain.text = "Marker Color"
            cell.optionLabel.text = device.getColorName().rawValue
            return cell
        }
        if indexPath.row == 6 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.makeEmpty()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 7 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Temperature"
            cell.lblSub.text = device.getTemperature()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Humidity"
            cell.lblSub.text = device.getHumidity()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 9 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Height Above Sea Level (m)"
            cell.lblSub.text = device.getHeightAboveSea()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Speed (mph)"
            cell.lblSub.text = device.getSpeed()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 11 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Direction (degrees from north)"
            cell.lblSub.text = device.getDirection()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 12 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Number of Satelittes in View"
            cell.lblSub.text = device.getNumberOfSattelites()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 13 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.makeEmpty()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 14 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Aqua ID"
            cell.lblSub.text = device.getAquaId()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 15 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Aqua Key"
            cell.lblSub.text = device.getAquaKey()
            cell.selectionStyle = .none
            return cell
        }
        if indexPath.row == 16 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
            cell.lblMain.text = "Phone Number"
            cell.lblSub.text = device.getPhoneNumber()
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQInfoSimpleCell") as! AQInfoSimpleCell
        cell.makeEmpty()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 || indexPath.row == 3 {
            return 120
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 5 {
            showColorsOptions()
        }
    }
    
    func showColorsOptions() {
        let actionSheetController = UIAlertController(title: "Marker Colors", message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        let color1ActionButton = UIAlertAction(title: "Blue", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.blueColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color1ActionButton)
        let color2ActionButton = UIAlertAction(title: "Green", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.greenColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color2ActionButton)
        let color3ActionButton = UIAlertAction(title: "Orange", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.orangeColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color3ActionButton)
        let color4ActionButton = UIAlertAction(title: "Violet", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.violetColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color4ActionButton)
        let color5ActionButton = UIAlertAction(title: "Rose", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.roseColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color5ActionButton)
        let color6ActionButton = UIAlertAction(title: "Magenta", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.magentaColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color6ActionButton)
        let color7ActionButton = UIAlertAction(title: "Azure", style: .default) { action -> Void in
            self.device.markerColor = AQMarkerColors.azureColor.rawValue
            AQDevice.updateDevice(device: self.device)
            self.tableView.reloadData()
        }
        actionSheetController.addAction(color7ActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
}
