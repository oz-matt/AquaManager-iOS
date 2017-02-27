//
//  AQFilterListViewController.swift
//  AquaManager
//
//  Created by Anton on 2/4/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

protocol AQFilterListDelegate {
    func updatedData(devices: [AQDevice], geofences: [AQGeofence])
}

class AQFilterCell: UITableViewCell {
    
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    func selectedImage(sel: Bool) {
        if sel {
            iconImage.image = UIImage(named: "selected")
        }
        else {
            iconImage.image = UIImage(named: "deselected")
        }
    }
}

enum SelectMode {
    case single
    case multiple
}

enum FilterMode {
    case all
    case devices
    case geofences
}

class AQFilterListViewController: AQBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AQFilterListDelegate! = nil
    
    var selectedDevices: [AQDevice] = [AQDevice]()
    var selectedGeofences: [AQGeofence] = [AQGeofence]()
    
    var allDevices: [AQDevice] = [AQDevice]()
    var allGeofences: [AQGeofence] = [AQGeofence]()
    
    var selectMode: SelectMode = .multiple
    var filterMode: FilterMode = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Filter"
        if filterMode == .devices {
            self.title = "Select Device"
        }
        if filterMode == .geofences {
            self.title = "Select Geofence"
        }
        self.allDevices = AQDeviceManager.manager.devices
        self.allGeofences = AQGeofenceManager.manager.geofences
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.delegate.updatedData(devices: selectedDevices, geofences: selectedGeofences)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterMode == .all {
            if section == 0 {
                return allDevices.count
            }
            return allGeofences.count
        }
        if filterMode == .devices {
            if section == 0 {
                return allDevices.count
            }
            return 0
        }
        if filterMode == .geofences {
            if section == 1 {
                return allGeofences.count
            }
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let dev = allDevices[indexPath.row]
            addDeviceToSelected(device: dev)
            self.tableView.reloadData()
        }
        if indexPath.section == 1 {
            let geo = allGeofences[indexPath.row]
            addGeofenceToSelected(geofence: geo)
            self.tableView.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQFilterCell") as! AQFilterCell
            let dev = allDevices[indexPath.row]
            cell.selectedImage(sel: self.isDeviceSelected(device: dev))
            cell.lblText.text = dev.getName()
            return cell
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AQFilterCell") as! AQFilterCell
            let geo = allGeofences[indexPath.row]
            cell.selectedImage(sel: self.isGeofenceSelected(geofence: geo))
            cell.lblText.text = geo.getName()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && allDevices.count > 0 && (filterMode == .all || filterMode == .devices) {
            return 40
        }
        if section == 1 && allGeofences.count > 0 && (filterMode == .all || filterMode == .geofences) {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 && allDevices.count > 0 && (filterMode == .all || filterMode == .devices) {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            label.font = UIFont(name: AQFonts.FONT_MEDIUM, size: 16)
            label.backgroundColor = UIColor.lightGray
            label.text = "Devices"
            label.textAlignment = .center
            label.textColor = .white
            
            return label
        }
        if section == 1 && allGeofences.count > 0 && (filterMode == .all || filterMode == .geofences) {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
            label.font = UIFont(name: AQFonts.FONT_MEDIUM, size: 16)
            label.textAlignment = .center
            label.backgroundColor = UIColor.lightGray
            label.text = "Geofences"
            label.textColor = .white
            return label
        }
        return nil
    }
    
    func isDeviceSelected(device: AQDevice) -> Bool {
        for dev in selectedDevices {
            if dev.aquaId != nil && dev.aquaId == device.aquaId {
                return true
            }
        }
        return false
    }
    
    func isGeofenceSelected(geofence: AQGeofence) -> Bool {
        for geo in selectedGeofences {
            if geo.name != nil && geo.name == geofence.name {
                return true
            }
        }
        return false
    }
    
    func addDeviceToSelected(device: AQDevice) {
        var index = 0
        var indexToRemove = -1
        for dev in selectedDevices {
            if dev.aquaId != nil && dev.aquaId == device.aquaId {
                indexToRemove = index
            }
            index += 1
        }
        if indexToRemove == -1 {
            selectedDevices.append(device)
            if selectMode == .single {
                self.delegate.updatedData(devices: [device], geofences: [AQGeofence]())
                self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            selectedDevices.remove(at: indexToRemove)
        }
    }
    
    func addGeofenceToSelected(geofence: AQGeofence) {
        var index = 0
        var indexToRemove = -1
        for geo in selectedGeofences {
            if geo.name != nil && geo.name == geofence.name {
                indexToRemove = index
            }
            index += 1
        }
        if indexToRemove == -1 {
            selectedGeofences.append(geofence)
            if selectMode == .single {
                self.delegate.updatedData(devices: [AQDevice](), geofences: [geofence])
                self.dismiss(animated: true, completion: nil)
            }
        }
        else {
            selectedGeofences.remove(at: indexToRemove)
        }
    }
}
