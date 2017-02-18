//
//  AQNavigationViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQNavigationViewController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = AQColor.DARK_BLUE_BASIC
        self.setBottomBorderColor(self.navigationBar.barTintColor!, height: 1)
        
        let image = UIImage()
        self.navigationBar.setBackgroundImage(image, for: .any, barMetrics: .default)
        self.navigationBar.shadowImage = image
        
        
        self.setupFonts()
    }
    
    func setupFonts() {
        let Font = UIFont(name: AQFonts.FONT_SEMIBOLD, size: 20)
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: Font!]
    }
    
    func setBottomBorderColor(_ color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: self.navigationBar.frame.height, width: self.navigationBar.frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        self.navigationBar.addSubview(bottomBorderView)
    }
}
