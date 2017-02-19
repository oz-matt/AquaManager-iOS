//
//  AQNotificationInfoViewController.swift
//  AquaManager
//
//  Created by Anton on 2/16/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQNotInfoCell: UITableViewCell {
    
    @IBOutlet weak var lblSub: UILabel!
    @IBOutlet weak var lblMain: UILabel!
}

class AQNotificationInfoViewController: AQBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var not: AQNotification = AQNotification()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        self.title = "Notification Info"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQNotInfoCell") as! AQNotInfoCell
        
        if indexPath.row == 0 {
            cell.lblMain.text = "Device Name"
            cell.lblSub.text = not.aquaname
        }
        if indexPath.row == 1 {
            cell.lblMain.text = "Aqua Key"
            cell.lblSub.text = not.aquakey
        }
        if indexPath.row == 2 {
            cell.lblMain.text = "Trigger"
            cell.lblSub.text = not.trigger
        }
        if indexPath.row == 3 {
            cell.lblMain.text = "Geofence"
            if not.geoname != nil {
               cell.lblSub.text = not.geoname
            }
            else {
               cell.lblSub.text = "--"
            }
            
        }
        if indexPath.row == 4 {
            cell.lblMain.text = "Trigger Frequency"
            if not.continuous == true {
               cell.lblSub.text = "Continuous"
            }
            else {
                cell.lblSub.text = "On Change"
            }
            
        }
        if indexPath.row == 5 {
            cell.lblMain.text = ""
            cell.lblSub.text = ""
        }
        if indexPath.row == 6 {
            cell.lblMain.text = "Alert"
            cell.lblSub.text = not.alert
        }
        if indexPath.row == 7 {
            cell.lblMain.text = "Alert Target"
            cell.lblSub.text = not.target
        }
        if indexPath.row == 8 {
            cell.lblMain.text = ""
            cell.lblSub.text = ""
        }
        if indexPath.row == 9 {
            cell.lblMain.text = "ID"
            cell.lblSub.text = not.getUniqueId()
        }
        
        return cell
    }
}
