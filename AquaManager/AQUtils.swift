//
//  AQUtils.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Alamofire

class CachedLocation {
    var short: String = ""
    var long: String = ""
}

class AQUtils {
    static var locations: [String: CachedLocation] = [String: CachedLocation]()
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func getTitleDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE MMM dd hh:mm:ss ZZZZ yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func getLocationStringShort(location: CLLocationCoordinate2D?, completion: @escaping (String) -> ()) {
        
        if location != nil {
            let latlon: String = "\(location!.latitude),\(location!.longitude)"
            if AQUtils.hasCachedLocation(latlon: latlon) != nil && !AQUtils.hasCachedLocation(latlon: latlon)!.short.blank {
               completion(AQUtils.hasCachedLocation(latlon: latlon)!.short)
               return
            }
            let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latlon)&key=AIzaSyAeHtCDX8llqpxW-xOHZ-nyBPHvKGDeOIw"
            AlamofireManger.sharedInstance.Get(url, params: nil, headers: nil, completion: { (response) in
                
                if let json = response.result.value as? [String: Any] {
                    let array: NSArray = json["results"] as! NSArray
                    if array.count > 2 {
                        let dict: NSDictionary = array[2] as! NSDictionary
                        let result = dict["formatted_address"] as! String
                        var loc = AQUtils.hasCachedLocation(latlon: latlon)
                        if loc == nil {
                            loc = CachedLocation()
                        }
                        loc!.short = result
                        AQUtils.addLocation(latlon: latlon, location: loc!)
                        completion(result)
                    }
                    else if array.count > 0 {
                        let dict: NSDictionary = array[0] as! NSDictionary
                        let result = dict["formatted_address"] as! String
                        var loc = AQUtils.hasCachedLocation(latlon: latlon)
                        if loc == nil {
                            loc = CachedLocation()
                        }
                        loc!.long = result
                        AQUtils.addLocation(latlon: latlon, location: loc!)
                        completion(result)
                    }
                    else {
                        completion("Unknown")
                    }
                    
                }
            })
        }
        else {
            completion("Unknown")
        }
    }
    
    static func getLocationStringLong(location: CLLocationCoordinate2D?, completion: @escaping (String) -> ()) {
        
        if location != nil {
            let latlon: String = "\(location!.latitude),\(location!.longitude)"
            if AQUtils.hasCachedLocation(latlon: latlon) != nil && !AQUtils.hasCachedLocation(latlon: latlon)!.long.blank {
                completion(AQUtils.hasCachedLocation(latlon: latlon)!.long)
                return
            }
            let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latlon)&key=AIzaSyAeHtCDX8llqpxW-xOHZ-nyBPHvKGDeOIw"
            AlamofireManger.sharedInstance.Get(url, params: nil, headers: nil, completion: { (response) in
                
                if let json = response.result.value as? [String: Any] {
                    let array: NSArray = json["results"] as! NSArray
                    if array.count > 0 {
                        let dict: NSDictionary = array[0] as! NSDictionary
                        let result = dict["formatted_address"] as! String
                        var loc = AQUtils.hasCachedLocation(latlon: latlon)
                        if loc == nil {
                            loc = CachedLocation()
                        }
                        loc!.long = result
                        AQUtils.addLocation(latlon: latlon, location: loc!)
                        completion(result)
                    }
                    else {
                        completion("Unknown")
                    }
                    
                }
            })
        }
        else {
            completion("Unknown")
        }
    }
    
    static func hasCachedLocation(latlon: String) -> CachedLocation? {
        return AQUtils.locations[latlon]
    }
    
    static func addLocation(latlon: String, location: CachedLocation) {
        AQUtils.locations[latlon] = location
    }
    
    /*static func updateLabelForAdress(label: UILabel, device: AQDevice, index: Int) {
        DispatchQueue.main.async {
            label.text = "Loading..."
        }
        let location: CLLocationCoordinate2D? = device.getLocation(index: index)
        if location != nil {
            GMSGeocoder().reverseGeocodeCoordinate(location!, completionHandler: { (response, error) in
                if error == nil && response != nil {
                    let array = response!.results()
                    if array != nil && array!.count > 0 {
                        let result: GMSAddress = array![0]
                        var text = ""
                        if result.locality != nil {
                            text = result.locality!
                        }
                        if result.administrativeArea != nil {
                            text = text + ", \(result.administrativeArea!)"
                        }
                        if result.country != nil {
                            text = text + ", \(result.country!)"
                        }
                        DispatchQueue.main.async {
                            label.text = text
                        }
                        
                    }
                }
            })
        }
    }*/
    
    static func getBoundingBox(coordinate: CLLocationCoordinate2D, radius: Double) -> [Double] {
        let rad = radius * 1609.34
        var box = [Double]()
        let latRadian = coordinate.latitude * (M_PI / 180.0)
        let degLatKm = 110.574235
        let degLongKm = 110.572833 * cos(latRadian)
        let deltaLat = rad / 1000 / degLatKm
        let deltaLong = rad / 1000 / degLongKm
        
        let minLat = coordinate.latitude - deltaLat
        let minLong = coordinate.longitude - deltaLong
        let maxLat = coordinate.latitude + deltaLat
        let maxLon = coordinate.longitude + deltaLong
        // miny minx maxy maxx
        box.append(minLat)
        box.append(minLong)
        box.append(maxLat)
        box.append(maxLon)
        return box
    }
    
    static func drawCircle(position: CLLocationCoordinate2D, radius: Float, mapView: GMSMapView) {
        let circ = GMSCircle(position: position, radius: Double(radius * 1609.34))
        circ.fillColor = AQColor.AREA_COLOR
        circ.strokeWidth = 4
        circ.strokeColor = AQColor.AREA_BORDER_COLOR
        circ.map = mapView
    }
    
    static func drawRect(coordinates: [Double], mapView: GMSMapView) {
        if coordinates.count != 16 {
            return 
        }
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[2], longitude: coordinates[3]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[4], longitude: coordinates[5]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[6], longitude: coordinates[7]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[8], longitude: coordinates[9]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[10], longitude: coordinates[11]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[12], longitude: coordinates[13]))
        path.add(CLLocationCoordinate2D(latitude: coordinates[14], longitude: coordinates[15]))

        let rect = GMSPolygon(path: path)
        rect.fillColor = AQColor.AREA_COLOR
        rect.strokeWidth = 5
        rect.strokeColor = AQColor.AREA_BORDER_COLOR
        rect.map = mapView
    }
    
    /*private static double[] getBoundingBox(final double pLatitude, final double pLongitude, final double pDistanceInMeters) {
    
    final double[] boundingBox = new double[4];
    
    final double latRadian = Math.toRadians(pLatitude);
    
    final double degLatKm = 110.574235;
    final double degLongKm = 110.572833 * Math.cos(latRadian);
    final double deltaLat = pDistanceInMeters / 1000.0 / degLatKm;
    final double deltaLong = pDistanceInMeters / 1000.0 /
    degLongKm;
    
    final double minLat = pLatitude - deltaLat;
    final double minLong = pLongitude - deltaLong;
    final double maxLat = pLatitude + deltaLat;
    final double maxLong = pLongitude + deltaLong;
    
    boundingBox[0] = minLat;
    boundingBox[1] = minLong;
    boundingBox[2] = maxLat;
    boundingBox[3] = maxLong;
    
    return boundingBox;
    }*/
}
