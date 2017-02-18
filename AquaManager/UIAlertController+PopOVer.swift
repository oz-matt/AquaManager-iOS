//
//  UIAlertController+PopOVer.swift
//  AquaManager
//
//  Created by Anton on 2/11/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func showInView(view: UIView) {
        let pop = self.popoverPresentationController
        pop?.sourceView = view
        pop?.sourceRect = view.bounds
    }
}
