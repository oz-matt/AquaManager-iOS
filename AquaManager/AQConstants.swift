//
//  AQConstants.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

enum AQColor {
    static let DARK_BLUE_BASIC = UIColor(red: 0 / 255.0, green: 49.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    static let BLUE_BASIC = UIColor(red: 26 / 255.0, green: 124.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0)
    
    static let AREA_BORDER_COLOR = UIColor(red: 102 / 255.0, green: 204.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    static let AREA_COLOR = UIColor(red: 0 / 255.0, green: 49.0 / 255.0, blue: 60.0 / 255.0, alpha: 0.5)
}

enum AQConstants {
    static let REQUEST_TIMEOUT : Double = 15.0
}

enum AQFonts {
    static let FONT_BOLD     = "AvenirNext-Bold"
    static let FONT_SEMIBOLD = "AvenirNext-DemiBold"
    static let FONT_REGULAR   = "AvenirNext-Regular"
    static let FONT_MEDIUM   = "AvenirNext-Medium"
}

enum AQMarkerColors: String {
    case blueColor = "Blue"
    case greenColor = "Green"
    case orangeColor = "Orange"
    case  violetColor = "Violet"
    case  roseColor = "Rose"
    case  magentaColor = "Magenta"
    case  azureColor = "Azure"
}
