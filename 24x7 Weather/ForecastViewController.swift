//
//  ForecastViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 23/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    var forecastModel: ForecastDataModel?

    @IBOutlet weak var weatherView: WeatherView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if forecastModel != nil {
            weatherView.displayWeatherInfo(weather: forecastModel!.forecastWeather!, isForecast:  true)
            weatherView.cityImageView.image = forecastModel?.imageName
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        weatherView.stopSpeech()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
