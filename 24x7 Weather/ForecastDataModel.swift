//
//  ForecastDataModel.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 23/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class ForecastDataModel: NSObject {

    var index = 0
    var forecastWeather: WeatherModel?
    var imageName: UIImage?
    
    convenience init(index: Int, forecastWeather: WeatherModel, imageName: UIImage) {
        self.init()
        self.index = index
        self.forecastWeather = forecastWeather
        self.imageName = imageName
    }
    
}
