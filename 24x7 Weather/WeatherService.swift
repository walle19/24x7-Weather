//
//  WeatherService.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 20/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(_ weather: WeatherModel)
    func setWeatherForecast(_ weathers: [WeatherModel])
    func setCityImage(_ cityImageURL: URL?)
}

class WeatherService {
    
    private struct Constants {
        static let AppID = "d878f9a2dcd60b865e4a5d78d3b04489"
        static let ImageAppID = "5184015-9e57e23119252b9be7434389e"
        
        static let WeatherUnit = "metric"
        static let BaseURL = "http://api.openweathermap.org/data/2.5/weather?q=%@&units=%@&appid=%@"
        static let ForecastBaseURL = "http://api.openweathermap.org/data/2.5/forecast?q=%@&units=%@&appid=%@"
        static let ImageBaseURL = "https://pixabay.com/api/?key=%@&q=%@-city&image_type=photo&pretty=true"
    }
    
    var delegate: WeatherServiceDelegate?
    
    func getWeather(_ cityString: String){
        
        /*
         Adding % encoding in city string.
         For instance,
         old string: New York
         new string: New%20York
         */
        let formattedCityName = cityString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        let path = String(format:Constants.BaseURL, formattedCityName!, Constants.WeatherUnit, Constants.AppID)
        
        let url = URL(string: path)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if data == nil {
                print("No data")
                return
            }
            
            let json = JSON(data: data!)
            
            let weather = WeatherModel(data: json, cityName: cityString)
            
            if self.delegate != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.setWeather(weather)
                })
            }
        })
        
        task.resume()
    }
    
    func getForecastWeather(_ cityString: String) {
        
        /*
         Adding % encoding in city string.
         For instance,
         old string: New York
         new string: New%20York
         */
        let formattedCityName = cityString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        let path = String(format:Constants.ForecastBaseURL, formattedCityName!, Constants.WeatherUnit, Constants.AppID)
        
        let url = URL(string: path)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if data == nil {
                print("No data")
                return
            }
            
            let json = JSON(data: data!)
            
            var weathers = [WeatherModel]()
            
            for weather in json["list"] {
                
                let dateStamp = weather.1["dt_txt"].stringValue
                
                // Skip the hours other than 00:00:00
                if dateStamp.range(of:"12:00:00") == nil {
                    continue
                }
                
                let forecast = WeatherModel(forecastData: weather.1, cityName: cityString)
                weathers.append(forecast)
            }
            
            if self.delegate != nil {
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.setWeatherForecast(weathers)
                })
            }
        })
        
        task.resume()
    }
    
    func getCityImage(_ cityString: String) {
        /*
         Adding % encoding in city string.
         For instance,
         old string: New York
         new string: New%20York
         */
        let formattedCityName = cityString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
        
        let path = String(format:Constants.ImageBaseURL, Constants.ImageAppID,formattedCityName!)
        
        let url = URL(string: path)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: {(data, response, error) -> Void in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if data == nil {
                print("No data")
                return
            }
            
            var isImageFetched = false
            
            let json = JSON(data: data!)
            if let hits = json["hits"].array {
                if hits.count > 0 {
                    let imageURLString: String = hits[1]["previewURL"].stringValue
                    let cityImageURL = URL(string: imageURLString)
                    if self.delegate != nil {
                        isImageFetched = true
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.delegate?.setCityImage(cityImageURL!)
                        })
                    }
                }
            }
            
            if !isImageFetched {
                if self.delegate != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.delegate?.setCityImage(nil)
                    })
                }
            }
        })
        
        task.resume()
    }
}
