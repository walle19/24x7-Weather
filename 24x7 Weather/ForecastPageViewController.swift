//
//  ForecastPageViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 23/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class ForecastPageViewController: UIPageViewController, WeatherServiceDelegate {

    let weatherService = WeatherService()
    
    var cityName: String! = nil
    var selectedCityImage: UIImage! = nil
    
    var forecastWeathers = [WeatherModel]()

    // MARK: View Controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        if cityName != nil {
            weatherService.delegate = self
            weatherService.getForecastWeather(cityName)
        }
        else {
            Helper.showAlertMessage(message: "Oops! Invalid city name", sender: self)
        }
        
        self.navigationItem.title = "Forecast"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set custom back button
        self.navigationItem.hidesBackButton = true
        let backImage = #imageLiteral(resourceName: "back_icon")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButton))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Back Button

    func backButton() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Weather Service Delegate
    
    func setWeather(_ weather: WeatherModel) {
        /*
         Empty as not required to be implemented here
         */
    }
    
    func setCityImage(_ cityImageURL: URL?) {
        /*
         Empty as not required to be implemented here
         */
    }
    
    func setWeatherForecast(_ weathers: [WeatherModel]) {
        
        forecastWeathers = weathers
        
        if let initialWalkThroughVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([initialWalkThroughVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: Navigation
    
    func nextPageWithIndex(index: Int) {
        
    }
    
    fileprivate func viewControllerAtIndex(index: Int) -> ForecastViewController? {
        if index == NSNotFound || index < 0 || index >= self.forecastWeathers.count {
            return nil
        }
        
        if let forecastVC = storyboard?.instantiateViewController(withIdentifier: "forecastVC") as? ForecastViewController {
            
            forecastVC.forecastModel = ForecastDataModel(index: index, forecastWeather: forecastWeathers[index], imageName: selectedCityImage)
            return forecastVC
        }
        
        return nil
    }
    
}

// MARK: UIPageViewControllerDataSource

extension ForecastPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ForecastViewController).forecastModel!.index
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ForecastViewController).forecastModel!.index
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
    
}
