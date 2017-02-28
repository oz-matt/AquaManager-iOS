//
//  AQMainMapViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import GoogleMaps

class AQMainMapViewController: AQBaseViewController, AQFilterListDelegate, GMSMapViewDelegate {
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
        self.mapsView.delegate = self
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
                self.addMarkerToMap(device: dev)
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
        marker.title = "Geofence: \(geofence.getName())"
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

        for marker in markersList {
            bounds = bounds.includingCoordinate(marker.position)
            pointsCount += 1
        }
        
        for geo in geofencesList {
            if geo.isCircle {
                let circ = GMSCircle(position: geo.getLocation(), radius: Double(geo.radius * 1609.34))
                bounds = bounds.includingBounds(circ.bounds())
            }
            else {
                if let path = AQUtils.getPath(coordinates: geo.getCoordinates()) {
                    bounds = bounds.includingPath(path)
                }
            }
        }
        self.mapsView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50))
        if mapsView.camera.zoom <= 4 {
           self.mapsView.animate(toZoom: 10)
        }
        
    }
    
    func addMarkerToMap(device: AQDevice) {
        if device.aqsens != nil {
            let count = device.aqsens!.count
            if count > 0 {
                //draw markers and path
                let path = GMSMutablePath()
                
                var currentIndex = 0
                let alphaDelta: Double = 1.0 / Double(count)
                for sens in device.aqsens! {
                    if currentIndex > AQSettingsManager.manager.getNumberOfMarkers() - 1 {
                       break
                    }
                    if let loc = sens.getLocation() {
                        path.add(loc)
                        let marker = GMSMarker(position: loc)
                        marker.updateWithSens(sens: sens, device: device, number: currentIndex + 1)
                        marker.map = self.mapsView
                        marker.zIndex = Int32(count - currentIndex)
                        print("added marker \(currentIndex)")
                        marker.iconView!.alpha = CGFloat(1.0 - Double(currentIndex) * alphaDelta)
                        self.markersList.append(marker)
                    }
                    currentIndex += 1
                }
                
                let line: GMSPolyline = GMSPolyline(path: path)
                line.strokeWidth = 2
                line.strokeColor = device.getPathColor()
                line.map = self.mapsView
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if marker.userData != nil {
           let sens = marker.userData as! AQSensData
            let vc = AQControllerFactory.factory.getTextViewController()
            vc.textToShow = sens.toJSONString(prettyPrint: true)!
            vc.title = AQUtils.getTitleDate(date: sens.getDate())
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func handleZoomInButton(_ sender: UIButton) {
        self.mapsView.animate(toZoom: self.mapsView.camera.zoom + 1)
    }
    
    @IBAction func handleZoomOutButton(_ sender: UIButton) {
        self.mapsView.animate(toZoom: self.mapsView.camera.zoom - 1)
    }
    
}
