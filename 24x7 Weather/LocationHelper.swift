//
//  LocationHelper.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 23/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit
import CoreLocation

class Helper {
    
    struct AlertConstants {
        static let AlertTitle = "24x7"
        static let AlertOk = "OK"
    }
    
    class func getAddressFor(location: CLLocation, completionHandler:@escaping (_ city: String) -> ()) {
        // Reverse geocoding
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:  { (placemarks, error) -> Void in
            if let placeMark = placemarks?[0] {
                // City
                if let city = placeMark.addressDictionary!["City"] as? String {
                    print(city, terminator: "")
                    completionHandler(city as String)
                }
            }
            
        })
    }
    
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: Constants.AlertConstants.AlertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: Constants.AlertConstants.AlertOk, style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
