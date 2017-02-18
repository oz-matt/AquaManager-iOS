//
//  AQIntroViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQIntroViewController: AQBaseViewController {

    @IBOutlet weak var buttonStart: UIButton!
    
    @IBAction func handleButtonStart(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AQNavigationViewController") as! AQNavigationViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}
