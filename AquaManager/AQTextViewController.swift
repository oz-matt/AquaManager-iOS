//
//  AQTextViewController.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQTextViewController: AQBaseViewController {
    
    var textToShow: String = ""
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = textToShow
    }
}
