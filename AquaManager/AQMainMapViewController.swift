//
//  AQMainMapViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import GoogleMaps

class AQMainMapViewController: AQBaseViewController, AQFilterListDelegate {
    @IBOutlet weak var mapsView: GMSMapView!
    
    var devicesList: [AQDevice] = [AQDevice]()
    var markersList: [GMSMarker] = [GMSMarker]()
    var geofencesList: [AQGeofence] = [AQGeofence]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Map"
        mapsView.mapType = AQSettingsManager.manager.getGoogleMapType()
        let icon = AQUtils.resizeImage(image: UIImage(named:"add")!, targetSize: CGSize(width: 22, height: 22))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(AQMainMapViewController.showFilterScreen))
        self.updateMapMarkers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func showFilterScreen() {
        let vc = AQControllerFactory.factory.getFilterListViewController()
        vc.delegate = self
        vc.selectedDevices = [AQDevice]()
        vc.selectedDevices.append(contentsOf: devicesList)
        vc.selectedGeofences = [AQGeofence]()
        vc.selectedGeofences.append(contentsOf: geofencesList)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updatedData(devices: [AQDevice], geofences: [AQGeofence]) {
        devicesList = devices
        geofencesList = geofences
        self.updateMapMarkers()
    }
    
    func updateMapMarkers() {
        self.markersList = [GMSMarker]()
        self.mapsView.clear()
        DispatchQueue.main.async {
            var markerCount = 0
            for dev in self.devicesList {
                if markerCount < AQSettingsManager.manager.getNumberOfMarkers() {
                   self.addMarkerToMap(device: dev)
                }
                else {
                    break
                }
                markerCount += 1
            }
            for geo in self.geofencesList {
                self.addGeofenceMarker(geofence: geo)
            }
            self.setCameraProperly()
        }
    }
    
    func addGeofenceMarker(geofence: AQGeofence) {
        let marker = GMSMarker(position: geofence.getLocation())
        marker.icon = AQUtils.resizeImage(image: UIImage(named: "flagd")!, targetSize: CGSize(width: 90, height: 50))
        marker.title = geofence.getName()
        marker.map = self.mapsView
        self.markersList.append(marker)
        if geofence.isCircle {
            AQUtils.drawCircle(position: geofence.getLocation(), radius: geofence.radius, mapView: self.mapsView)
        }
        else {
            AQUtils.drawRect(coordinates: geofence.getCoordinates(), mapView: self.mapsView)
        }
    }
    
    func setCameraProperly() {
        var bounds = GMSCoordinateBounds()
        var pointsCount = 0
        var singleCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
        for marker in markersList {
            bounds = bounds.includingCoordinate(marker.position)
            pointsCount += 1
            singleCoordinate = marker.position
        }
        
        for geo in geofencesList {
            bounds = bounds.includingCoordinate(geo.getLocation())
        }
        
        if pointsCount > 1 {
           self.mapsView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
        }
        else {
           self.mapsView.animate(with: GMSCameraUpdate.setTarget(singleCoordinate, zoom: 0))
        }
    }
    
    func addMarkerToMap(device: AQDevice) {
        let position = device.getLocation(index: 0)
        if position != nil {
            let marker = GMSMarker(position: position!)
            marker.icon = device.getImageMarker()
            marker.map = self.mapsView
            self.markersList.append(marker)
        }
    }
    
    @IBAction func handleZoomInButton(_ sender: UIButton) {
        self.mapsView.animate(toZoom: self.mapsView.camera.zoom + 1)
    }
    
    @IBAction func handleZoomOutButton(_ sender: UIButton) {
        self.mapsView.animate(toZoom: self.mapsView.camera.zoom - 1)
    }
    
}
