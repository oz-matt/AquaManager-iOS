//
//  GMSMarker+AQSens.swift
//  AquaManager
//
//  Created by test on 2/28/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSMarker {
    func updateWithSens(sens: AQSensData, device: AQDevice, number: Int) {
        self.snippet = sens.getSnippet()
        self.userData = sens
        
        let icon = device.getImageMarker()
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 51))
        let uimage = UIImageView(frame: view.frame)
        uimage.image = icon
        let label: UILabel = UILabel(frame: CGRect(x: 2, y: 0, width: 26, height: 30))
        label.text = "\(number)"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        view.addSubview(uimage)
        view.addSubview(label)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        if number == 1 {
            let biggerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 81))
            var img: UIImage = UIImage(named: "selected_arrow")!
           img = AQUtils.resizeImage(image: img, targetSize: CGSize(width: 20, height: 20))
           let selImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
           selImg.image = img
           biggerView.addSubview(selImg)
           view.frame = CGRect(x: 0, y: 30, width: 30, height: 51)
           biggerView.addSubview(view)
           self.iconView = biggerView
            self.infoWindowAnchor = CGPoint(x: 0.5, y: 0.4)
        }
        else {
           self.iconView = view
        }
    }
}

extension GMSCircle {
    func bounds () -> GMSCoordinateBounds {
        func locationMinMax(positive : Bool) -> CLLocationCoordinate2D {
            let sign:Double = positive ? 1 : -1
            let dx = sign * self.radius  / 6378000 * (180/M_PI)
            let lat = position.latitude + dx
            let lon = position.longitude + dx / cos(position.latitude * M_PI/180)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        
        return GMSCoordinateBounds(coordinate: locationMinMax(positive: true),
                                   coordinate: locationMinMax(positive: false))
    }
}
