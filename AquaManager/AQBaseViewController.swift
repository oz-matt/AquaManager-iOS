//
//  AQBaseViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import ReachabilitySwift

class AQBaseViewController: UIViewController {
    
    var tap: UITapGestureRecognizer?
    var toastYOffset : Float = 150.0;
    var progressHUD = MBProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AQBaseViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(AQBaseViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

        self.tap = UITapGestureRecognizer(target: self, action: #selector(AQBaseViewController.dismissKeyboard))
        self.tap?.cancelsTouchesInView = false
        self.view.addGestureRecognizer(self.tap!)
        
        do {
            let reachability = try Reachability()!
            NotificationCenter.default.addObserver(self, selector: #selector(AQBaseViewController.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: reachability)
            try reachability.startNotifier()
        }
        catch {
            
        }
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func showHUDWithLabel(_ label: String) {
        print("Show HUD: \(self)")
        
        self.progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.progressHUD.color = AQColor.DARK_BLUE_BASIC
        self.progressHUD.labelText = label
        self.progressHUD.bringSubview(toFront: self.view)
        self.progressHUD.hide(true, afterDelay: AQConstants.REQUEST_TIMEOUT)
    }
    
    
    func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
    }
    
    func showLoadingHUD() {
    func showToastPopUp(_ text: String) {
        var toast = MBProgressHUD()
        toast = MBProgressHUD.showAdded(to: self.view, animated: true)
        // Configure for text only and offset down
        toast.mode = MBProgressHUDMode.text;
        toast.labelText = text
        toast.labelFont = UIFont(name: AQFonts.FONT_REGULAR, size: 12)!
        toast.margin = 10
        toast.yOffset = CGFloat(self.toastYOffset)
        toast.removeFromSuperViewOnHide = true
        toast.hide(true, afterDelay: 3)
    }
        self.showHUDWithLabel("")
    }
    
    func showCustomAlert(_ title: String, text: String) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func popViewController() {
        if self.navigationController != nil {
            _ = navigationController?.popViewController(animated: true)
            if self == self.navigationController?.viewControllers[0] {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func keyboardWillShow(_ notification: Notification) {
        self.toastYOffset = -150;
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.toastYOffset = 150;
    }
    
    func showConnectionAlert() {
        self.hideHUD()
        
        let hudInet = MBProgressHUD.showAdded(to: ((UIApplication.shared.delegate?.window)!)!, animated: true)
        hudInet.mode = .customView
        hudInet.removeFromSuperViewOnHide = true
        
        let customView: UIImageView = UIImageView.init(image: UIImage.init(named: "redclose"))
        customView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        hudInet.customView = customView
        hudInet.labelText = NSLocalizedString("lbl_no_internet", comment: "")
        hudInet.hide(true, afterDelay: 2)
    }
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction.init(title: "OK", style: .cancel) { [weak alertController] (action) in
            alertController?.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(actionOk)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAlertWithTitle(_ title: String, message: String, okButtonHandler: @escaping (UIAlertController?) -> Void) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction.init(title: "OK", style: .cancel) { [weak alertController] (action) in
            alertController?.dismiss(animated: true, completion: nil)
            okButtonHandler(alertController)
        }
        
        alertController.addAction(actionOk)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func isInternetAvailable() -> Bool {
        var reachability: Reachability
        
        do {
            reachability = Reachability()!
            if !reachability.isReachable {
                showConnectionAlert()
                return false
            }
            return true
        }
        catch {
            print(error)
        }
        return false
    }
    
    func reachabilityChanged(_ note: Foundation.Notification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                
            }
        } else {
            showConnectionAlert()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
