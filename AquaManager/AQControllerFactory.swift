//
//  AQControllerFactory.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQControllerFactory {
    static let factory = AQControllerFactory()
    
    
    func getIntroScreen() -> AQIntroViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQIntroViewController") as! AQIntroViewController
        return vc
    }
    
    func getMainMapController() -> AQMainMapViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQMainMapViewController") as! AQMainMapViewController
        return vc
    }
    
    func getSettingsController() -> AQSettingsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQSettingsViewController") as! AQSettingsViewController
        return vc
    }
    
    func getRawDataList(device: AQDevice) -> AQRawDataListController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQRawDataListController") as! AQRawDataListController
        vc.device = device
        return vc
    }
    
    func getTextViewController() -> AQTextViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQTextViewController") as! AQTextViewController
        return vc
    }
    
    func getDeviceInfoController() -> AQDeviceInfoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQDeviceInfoViewController") as! AQDeviceInfoViewController
        return vc
        
    }
    
    func getFilterListViewController() -> AQFilterListViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQFilterListViewController") as! AQFilterListViewController
        return vc
    }
    
    func getAddGeofenceController() -> AQAddGeofenceViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQAddGeofenceViewController") as! AQAddGeofenceViewController
        return vc
    }
    
    func getGeofenceCreationController() -> AQGeofenceCreationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQGeofenceCreationViewController") as! AQGeofenceCreationViewController
        return vc
    }
    
    func getRemoveNotificationViewController() -> AQRemoveNotificationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQRemoveNotificationViewController") as! AQRemoveNotificationViewController
        return vc
    }
    
    func getAddNotificationViewController() -> AQAddNotificationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQAddNotificationViewController") as! AQAddNotificationViewController
        return vc
    }
    
    func getNavigationControllerWithRoot(vc: UIViewController) -> AQNavigationViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AloneNavigationViewController") as! AQNavigationViewController
        nav.viewControllers = [vc]
        return nav
    }
    
    func getNotificationInfoViewController() -> AQNotificationInfoViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQNotificationInfoViewController") as! AQNotificationInfoViewController
        return vc
    }
    
    func getFillNotificationInfoController() -> AQFillNotificationInfoController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQFillNotificationInfoController") as! AQFillNotificationInfoController
        return vc
    }
}
