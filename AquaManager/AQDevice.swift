//
//  AQDevice.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import ObjectMapper

class AQDevice: NSManagedObject {
    var aqsens: [AQSensData]?
    
    @NSManaged var name: String?
    @NSManaged var aqsensRaw: String?
    @NSManaged var aquaId: String?
    @NSManaged var aquaKey: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var markerColor: String?
    @NSManaged var pass: String?
    
    func getName() -> String? {
        return name
    }
    
    func getLocation(index: Int) -> CLLocationCoordinate2D? {
        let sens = getActiveSens(index: index)
        if sens != nil {
           return sens?.getLocation()
        }
        return nil
    }
    
    func getBatt() -> String {
        let sens = getActiveSens(index: 0)
        if sens != nil {
            let value: Int? = sens!.getBatteryValue()
            if value != nil {
               return "\(value!)%"
            }
        }
        return ""
    }
    
    func getActiveSens(index: Int) -> AQSensData? {
        if aqsens != nil && aqsens!.count > index {
            return aqsens![index]
        }
        return nil
    }
    
    func getRawDataIndex(index: Int) -> String {
        if aqsensRaw != nil {
            let array = aqsensRaw?.parseJSONString as! NSArray
            if array.count > index {
                let dict = array[index] as! NSDictionary
                return "\(dict)"
            }
        }
        return ""
    }
    
    func getColorName() -> AQMarkerColors {
        if markerColor != nil && AQMarkerColors(rawValue: markerColor!) != nil {
           return AQMarkerColors(rawValue: markerColor!)!
        }
        return AQMarkerColors.greenColor
    }
    
    func getPathColor() -> UIColor {
        let markerColor = self.getColorName()
        if markerColor == .blueColor {
            return .blue
        }
        if markerColor == .greenColor {
             return .green
        }
        if markerColor == .orangeColor {
             return .orange
        }
        if markerColor == .violetColor {
             return .purple
        }
        if markerColor == .roseColor {
             return .red
        }
        if markerColor == .magentaColor {
             return .magenta
        }
        if markerColor == .azureColor {
             return .cyan
        }

        return .blue
    }
    
    func getImageMarker() -> UIImage {
        let markerColor = self.getColorName()
        var image = UIImage(named: "green_marker")!
        if markerColor == .blueColor {
           image = UIImage(named: "blue_marker")!
        }
        if markerColor == .greenColor {
           image = UIImage(named: "green_marker")!
        }
        if markerColor == .orangeColor {
           image = UIImage(named: "orange_marker")!
        }
        if markerColor == .violetColor {
           image = UIImage(named: "violet_marker")!
        }
        if markerColor == .roseColor {
           image = UIImage(named: "rose_marker")!
        }
        if markerColor == .magentaColor {
           image = UIImage(named: "magenta_marker")!
        }
        if markerColor == .azureColor {
           image = UIImage(named: "azure_marker")!
        }
        image = AQUtils.resizeImage(image: image, targetSize: CGSize(width: 30, height: 51))
        return image
    }
    
    func getTemperature() -> String? {
        if aqsens == nil {
            return nil
        }
        
        if aqsens!.count > 0 {
           return aqsens?[0].sensorsData?.temperature
        }
        return nil
    }
    
    func getHumidity() -> String? {
        if aqsens?.count == 0 {
            return ""
        }
        
        let value = aqsens?[0].sensorsData?.humidity
        if value != nil {
            return "\(aqsens![0].sensorsData!.humidity!)"
        }
        return ""
    }
    
    func getHeightAboveSea() -> String? {
        if aqsens?.count == 0 {
            return ""
        }
        let value = aqsens?[0].gpsMinimum?.height
        if value != nil {
            return "\(aqsens![0].gpsMinimum!.height!)"
        }
        return ""
    }
    
    func getSpeed() -> String? {
        if aqsens?.count == 0 {
            return ""
        }
        let value = aqsens?[0].gpsMinimum?.gspeed
        if value != nil {
            return "\(aqsens![0].gpsMinimum!.gspeed!)"
        }
        return ""
    }
    
    func getDirection() -> String? {
        if aqsens?.count == 0 {
            return ""
        }
        let value = aqsens?[0].gpsMinimum?.direction
        if value != nil {
            return "\(aqsens![0].gpsMinimum!.direction!)"
        }
        return ""
    }
    
    func getNumberOfSattelites() -> String? {
        if aqsens?.count == 0 {
            return ""
        }
        let value = aqsens?[0].gpsMinimum?.numsat
        if value != nil {
            return "\(aqsens![0].gpsMinimum!.numsat!)"
        }
        return ""
    }
    
    func getAquaId() -> String? {
        return self.aquaId
    }
    
    func getAquaKey() -> String? {
        return self.aquaId
    }
    
    func getPhoneNumber() -> String? {
        return self.phoneNumber
    }
    
    func refillDeviceSens() {
        if self.aqsensRaw != nil {
            self.aqsens = Mapper<AQSensData>().mapArray(JSONString: self.aqsensRaw!)
        }
    }
}
