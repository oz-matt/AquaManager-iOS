//
//  UITextField+Placeholder.swift
//  AquaManager
//
//  Created by test on 2/27/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setUpdatePlaceholderColor() {
        if self.placeholder != nil {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                            attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        }
        
    }
}
