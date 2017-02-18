//
//  AQAddGeofenceViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import GoogleMaps
import UIKit
import CoreLocation

protocol AQAddGeofenceDelegate {
    func refreshList()
}

class AQAddGeofenceViewController: AQBaseViewController, GMSMapViewDelegate, AQGeofenceCreationDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    var tempGeofence: AQTempGeofence! = AQTempGeofence()
    var savingMode: Bool = false
    var delegate: AQAddGeofenceDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.mapType = AQSettingsManager.manager.getGoogleMapType()
        self.title = "Add Geofence"
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        if !savingMode {
            let vc = AQControllerFactory.factory.getGeofenceCreationController()
            vc.centerCoordinate = coordinate
            vc.delegate = self
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func createGeofence(geofence: AQTempGeofence) {
        savingMode = true
        infoLabel.isHidden = true
        cancelButton.isHidden = false
        saveButton.isHidden = false
        tempGeofence = geofence
        addMarker(position: tempGeofence.coordinate)
        if tempGeofence.isCircle {
            AQUtils.drawCircle(position: tempGeofence.coordinate, radius: tempGeofence.radius, mapView: mapView)
        }
        else {
            AQUtils.drawRect(position: tempGeofence.coordinate, radius: tempGeofence.radius, mapView: mapView)
        }
    }
    
    func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.icon = AQUtils.resizeImage(image: UIImage(named: "flagd")!, targetSize: CGSize(width: 90, height: 50))
        marker.title = tempGeofence.name
        marker.map = self.mapView

        self.mapView.animate(toLocation: position)
        self.mapView.selectedMarker = marker
    }

    @IBAction func handleCancelButton(_ sender: UIButton) {
        mapView.clear()
        savingMode = false
        infoLabel.isHidden = false
        cancelButton.isHidden = true
        saveButton.isHidden = true
    }

    @IBAction func handleSaveButton(_ sender: UIButton) {
        self.showLoadingHUD()
        let newGeofence = AQGeofence.createNewGeofence(name: tempGeofence.name)
        newGeofence.radius = tempGeofence.radius
        newGeofence.isCircle = tempGeofence.isCircle
        newGeofence.centerLat = tempGeofence.coordinate.latitude
        newGeofence.centerLon = tempGeofence.coordinate.longitude
        AQCoreDataManager.manager.saveContext()
        delegate.refreshList()
        self.navigationController?.popViewController(animated: true)
    }
}
