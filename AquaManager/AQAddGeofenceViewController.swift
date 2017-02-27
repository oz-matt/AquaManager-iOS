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
    
    var polygonMarkers: [GMSMarker] = [GMSMarker]()
    var polygon: GMSPolygon = GMSPolygon()
    
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
            drawPolygon()
        }
    }
    
    func drawPolygon() {
        // minx miny maxx maxy
        let box = AQUtils.getBoundingBox(coordinate: tempGeofence.coordinate, radius: Double(tempGeofence.radius))
        polygonMarkers = [GMSMarker]()
        let middeltaX = (box[3] - box[1])/2
        let middeltaY = (box[2] - box[0])/2
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[0], longitude: box[1]))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[0], longitude: box[1] + middeltaX))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[0], longitude: box[3]))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[0] + middeltaY, longitude:  box[3]))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[2], longitude: box[3]))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[2], longitude: box[3] - middeltaX))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[2], longitude: box[1]))
        self.addPolygonMarker(position: CLLocationCoordinate2D(latitude: box[2] - middeltaY, longitude: box[1]))
        self.updatePolygonArea()
    }
    
    func addPolygonMarker(position: CLLocationCoordinate2D) {
        let mark = GMSMarker(position: position)
        mark.icon = AQUtils.resizeImage(image: UIImage(named: "orb")!, targetSize: CGSize(width: 30, height: 30))
        mark.map = self.mapView
        mark.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        mark.isDraggable = true
        polygonMarkers.append(mark)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        updatePolygonArea()
    }
    
    func updatePolygonArea() {
        let path = GMSMutablePath()
        
        for mark in polygonMarkers {
            path.add(mark.position)
        }
        
        if polygon != nil {
            polygon.map = nil
        }
        
        polygon = GMSPolygon(path: path)
        polygon.fillColor = AQColor.AREA_COLOR
        polygon.strokeWidth = 5
        polygon.strokeColor = AQColor.AREA_BORDER_COLOR
        polygon.map = mapView
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
        
        if tempGeofence.isCircle == false {
            var arr = [Double]()
            for mark in polygonMarkers {
                arr.append(mark.position.latitude)
                arr.append(mark.position.longitude)
            }
            newGeofence.coordinates = NSKeyedArchiver.archivedData(withRootObject: arr)
        }
        
        AQCoreDataManager.manager.saveContext()
        NotificationCenter.default.post(Notification(name: Notification.Name.showToastMessage, object: nil, userInfo: ["text": "Geofence created."]))
        delegate.refreshList()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleZoomInButton(_ sender: UIButton) {
        self.mapView.animate(toZoom: self.mapView.camera.zoom + 1)
    }
    
    @IBAction func handleZoomOutButton(_ sender: UIButton) {
        self.mapView.animate(toZoom: self.mapView.camera.zoom - 1)
    }

}
