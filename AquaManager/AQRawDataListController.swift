//
//  AQRawDataListController.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQRawDataCell: UITableViewCell {
    
    @IBOutlet weak var rawDataLabel: UILabel!
}

class AQRawDataListController: AQBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var device: AQDevice!
    var data: [AQSensData] = [AQSensData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if device.aqsens != nil {
            data = device.aqsens!
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        self.title = "Raw Data List"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AQRawDataCell") as! AQRawDataCell
        var text = ""
        let element = data[indexPath.row]

        text = AQUtils.getTitleDate(date: element.getDate())
        
        cell.rawDataLabel.text = text
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = AQControllerFactory.factory.getTextViewController()
        let element = data[indexPath.row]
        vc.textToShow = device.getRawDataIndex(index: indexPath.row)
        vc.title = AQUtils.getTitleDate(date: element.getDate())
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
