//
//  City.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 20/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class City: NSObject, NSCoding {
    
    var cityName: String?
    
    struct PropertyKey {
        static let nameKey = "name"
        
        // MARK: Archive Path
        static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cities")
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cityName, forKey: PropertyKey.nameKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        self.init(name: name)
    }
    
    init?(name: String) {
        // Return nil if name string is empty
        if name.isEmpty {
            return nil
        }
        self.cityName = name
        
        super.init()
    }
    
    // MARK: NSCoding
    
    class func saveCity(city: City) -> Bool {
        var cities = getCities()
        
        if cities != nil {
            if cities!.contains(city) {
                return false
            }
            
            if cities!.index(where: { $0.cityName == city.cityName }) != nil {
                return false
            }
            
            cities?.append(city)
        }
        else {
            cities = [city]
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cities!, toFile: PropertyKey.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save cities...")
            return false
        }
        
        return true
    }
    
    class func removeCity(city: City) -> Bool {
        var cities = getCities()
        if  cities == nil || cities!.count == 0 {
            return false
        }
        
        if let index = cities!.index(where: { $0.cityName == city.cityName }) {
            cities?.remove(at: index)
        }
        else {
            return false
        }
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(cities!, toFile: PropertyKey.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save cities...")
            return false
        }
        
        return true
    }
    
    class func getCities() -> [City]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: PropertyKey.ArchiveURL.path) as? [City]
    }
}
