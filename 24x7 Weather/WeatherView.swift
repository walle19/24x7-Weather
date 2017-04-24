//
//  WeatherView.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 22/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit
import QuartzCore

class WeatherView: UIView {
    
    @IBOutlet weak var cityImageView: UIImageView! {
        didSet{
            cityImageView.addBlurEffect()
        }
    }
    
    @IBOutlet weak var maxTempLabel: UILabel! {
        didSet{
            maxTempLabel.setShadow()
        }
    }
    
    @IBOutlet weak var minTempLabel: UILabel! {
        didSet{
            minTempLabel.setShadow()
        }
    }
    
    @IBOutlet weak var tempLabel: UILabel! {
        didSet{
            tempLabel.setShadow()
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet{
            descriptionLabel.setShadow()
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel! {
        didSet{
            dateLabel.setShadow()
        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel! {
        didSet{
            cityNameLabel.setShadow()
        }
    }
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    
    let speechWeather = SpeechWeather()
    
    private struct Constants {
        static let Degree = "ºC"
        static let CityPlaceholderImage = "placeholder"
    }
    
    var cityImageName: String!
    
    // MARK: Display methods
    
    func displayWeatherInfo(weather: WeatherModel, isForecast: Bool) {
        let tempValue = Double(weather.temp)
        tempLabel.text = String(format: "%.2f %@", tempValue!, Constants.Degree)
        
        let maxTempValue = Double(weather.maxTemp)
        maxTempLabel.text = String(format: "%.2f %@", maxTempValue!, Constants.Degree)

        let minTempValue = Double(weather.minTemp)
        minTempLabel.text = String(format: "%.2f %@", minTempValue!, Constants.Degree)
        
        descriptionLabel.text = weather.description
        weatherIconImageView.image = UIImage(named: weather.icon)
        
        if weather.dateTimeStamp != "" {
            if let dateString = Double(weather.dateTimeStamp)?.getFullDateStringFromUTC() {
                dateLabel.text = dateString
            }
        }
        
        if cityNameLabel != nil {
            cityNameLabel.text = weather.cityName
        }
        
        // Speak the current weather
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isPlay") {
            speechWeather.setupSpeech(desc: descriptionLabel.text!, maxTemp: maxTempValue!, minTemp: minTempValue!, date: dateLabel?.text, isForecast: isForecast)
        }
        
    }
    
    func displayCityImage(cityImageURL: URL?) {
        if let url = cityImageURL {
            // Async call to get the city image
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                let imageData = try? Data(contentsOf: cityImageURL!)
                DispatchQueue.main.async {
                    if url == cityImageURL {
                        if imageData != nil {
                            self.cityImageView.image = UIImage(data: imageData!)
                        } else {
                            self.cityImageView.image = UIImage(named: Constants.CityPlaceholderImage)
                        }
                    }
                }
            }
        }
        else {
            self.cityImageView.image = UIImage(named: Constants.CityPlaceholderImage)
        }
    }

    // MARK: Stop Speech
    
    func stopSpeech() {
        speechWeather.stopSpeech()
    }
    
}

/*
 To add blur effect on the imageView
 */
extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.superview!.bounds
        blurEffectView.alpha = 0.3
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(blurEffectView)
        
        let topConstraint = NSLayoutConstraint(item: blurEffectView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: blurEffectView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: blurEffectView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: blurEffectView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0)
        self.addConstraints([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
}

/*
 Format the UTC timestamp to full date
 */
extension Double {
    func getFullDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "EEE dd/MM/yyyy"
        
        return dateFormatter.string(from: date)
    }
}

/*
 Set shadow effect to the UILabels
 */
extension UILabel {
    func setShadow() {
        self.layer.shadowOffset = CGSize(width: -1, height: -1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
    }
}
