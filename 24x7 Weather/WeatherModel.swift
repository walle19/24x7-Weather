//
//  WeatherModel.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 20/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import Foundation

class WeatherModel {
    
    var cityName: String = ""
    
    var mainDescription: String = ""
    var description: String = ""
    
    var temp: String = ""
    var minTemp: String = ""
    var maxTemp: String = ""
    
    var icon: String = ""
    
    var pressure: String = ""
    
    var humidity: String = ""
    
    var windSpeed: String = ""
    var windDegree: String = ""
    
    var cloudiness: String = ""
    
    var snow: String = ""
    
    var rain: String = ""
    
    var sunriseTimeStamp: String = ""
    var sunsetTimeStamp: String = ""
    
    var visibility: String = ""
    
    var dateTimeStamp: String = ""
    
    init(data: JSON, cityName: String) {
        temp = data["main"]["temp"].stringValue
        minTemp = data["main"]["temp_min"].stringValue
        maxTemp = data["main"]["temp_max"].stringValue
        
        pressure = data["main"]["pressure"].stringValue
        
        humidity = data["main"]["humidity"].stringValue
        
        windSpeed = data["wind"]["speed"].stringValue
        windDegree = data["wind"]["deg"].stringValue
        
        cloudiness = data["clouds"]["all"].stringValue
        
        if let rainValue = data.dictionary?["rain"]?["3h"].stringValue {
            rain = rainValue
        }
        else {
            rain = "0"
        }
        
        if let snowValue = data.dictionary?["snow"]?["3h"].stringValue {
            snow = snowValue
        }
        else {
            snow = "0"
        }
        
        sunriseTimeStamp = data["sys"]["sunrise"].stringValue
        sunsetTimeStamp = data["sys"]["sunset"].stringValue
        
        visibility = data["visibility"].stringValue
        
        description = data["weather"][0]["description"].stringValue
        mainDescription = data["weather"][0]["main"].stringValue
        
        icon = data["weather"][0]["icon"].stringValue
        
        self.cityName = cityName
    }
    
    init(forecastData: JSON, cityName: String) {
        self.temp = forecastData["main"]["temp"].stringValue
        self.minTemp = forecastData["main"]["temp_min"].stringValue
        self.maxTemp = forecastData["main"]["temp_max"].stringValue
        self.description = forecastData["weather"][0]["description"].stringValue
        self.icon = forecastData["weather"][0]["icon"].stringValue
        self.dateTimeStamp = forecastData["dt"].stringValue
    }
}
