//
//  AQSettingsManager.swift
//  AquaManager
//
//  Created by Anton on 2/11/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import GoogleMaps

enum MapTypes: String {
    case normal = "Normal"
    case sattelite = "Sattelite"
    case hybrid = "Hybrid"
    case terrain = "Terrain"
}

class AQSettingsManager {
    static let manager = AQSettingsManager()
    
    let SETTINGS_SHOW_INTRO = "SettingsShowIntro"
    let SETTINGS_SHOW_GEOFENCES_ON_MAP = "SettingsShowGeofences"
    let SETTINGS_NUMBER_OF_MARKERS = "SettingsNumberOfMarkers"
    let SETTINGS_MAP_TYPE = "SettingsMapType"
    let defaults = UserDefaults.standard
    
    func getShowIntro() -> Bool {
        if defaults.value(forKey: SETTINGS_SHOW_INTRO) != nil {
           return defaults.bool(forKey: SETTINGS_SHOW_INTRO)
        }
        return true
    }
    
    func getGoogleMapType() -> GMSMapViewType {
        let type = self.getMapType()
        if type == .normal {
            return GMSMapViewType.normal
        }
        if type == .sattelite {
            return GMSMapViewType.satellite
        }
        if type == .hybrid {
            return GMSMapViewType.hybrid
        }
        if type == .terrain {
            return GMSMapViewType.terrain
        }
        return GMSMapViewType.normal
    }
    
    func setShowIntro(bool: Bool) {
        defaults.set(bool, forKey: SETTINGS_SHOW_INTRO)
        defaults.synchronize()
    }
    
    func getShowGeofences() -> Bool {
        if defaults.value(forKey: SETTINGS_SHOW_GEOFENCES_ON_MAP) != nil {
            return defaults.bool(forKey: SETTINGS_SHOW_GEOFENCES_ON_MAP)
        }
        return true
    }
    
    func setShowGeofences(bool: Bool) {
        defaults.set(bool, forKey: SETTINGS_SHOW_GEOFENCES_ON_MAP)
        defaults.synchronize()
    }
    
    func setNumberOfMarkers(number: Int) {
        defaults.set(number, forKey: SETTINGS_NUMBER_OF_MARKERS)
        defaults.synchronize()
    }
    
    func getNumberOfMarkers() -> Int {
        if defaults.object(forKey: SETTINGS_NUMBER_OF_MARKERS) != nil {
           return defaults.integer(forKey: SETTINGS_NUMBER_OF_MARKERS)
        }
        return 50
    }
    
    func getMapType() -> MapTypes {
        if defaults.object(forKey: SETTINGS_MAP_TYPE) != nil {
           let type = defaults.string(forKey: SETTINGS_MAP_TYPE)
           return MapTypes(rawValue: type!)!
        }
        return .normal
    }
    
    func setMapType(mapType: MapTypes) {
        defaults.set(mapType.rawValue, forKey: SETTINGS_MAP_TYPE)
        defaults.synchronize()
    }
}
