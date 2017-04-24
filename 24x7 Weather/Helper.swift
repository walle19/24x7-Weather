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
                else if let state = placeMark.addressDictionary!["State"] as? String {
                    print(state, terminator: "")
                    completionHandler(state as String)
                }
            }
            
        })
    }
    
    class func showAlertMessage(message: String!, sender: AnyObject!) {
        let alertController = UIAlertController(title: AlertConstants.AlertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: AlertConstants.AlertOk, style: UIAlertActionStyle.default, handler: nil))
        sender.present(alertController, animated: true, completion: nil)
    }
}
