//
//  WeatherViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 20/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit
import Social
import CoreLocation

class WeatherViewController: UIViewController, WeatherServiceDelegate, CLLocationManagerDelegate {
    
    let weatherService = WeatherService()
    
    var selectedWeather: WeatherModel?
    
    private let manager = CLLocationManager()
    
    private var location: CLLocation!
        
    @IBOutlet weak var weatherView: WeatherView!
    
    @IBOutlet weak var playStopBarButton: UIBarButtonItem!
    
    private struct Constants {
        struct AppConstants {
            static let kIsWalkThroughShown = "isWalkThroughShown"
        }
        
        struct AlertConstants {
            static let AlertFBErrorMessage = "You are not logged in to your Facebook account."
            static let AlertTwitterErrorMessage = "You are not logged in to your Twitter account."
        }
        
        struct ActionConstants {
            static let ActionFBTitle = "Share on Facebook"
            static let ActionTwitterTitle = "Share on Twitter"
            static let ActionMoreTitle = "More"
            static let ActionCloseTitle = "Close"
            
            static let ActionShareTitle = "Share"
            static let ActionShareMessage = "Weather at %@ is %@ (Temp. is %@)"
        }
        
        struct SegueIdentifiers {
            static let WeatherDetailSegueID = "weatherDetailSegue"
            static let UnwindWeatherSegueID = "unwindToWeather"
            static let ForecastSegueID = "forecastSegue"
            
            static let WalkThroughPageVCID = "walkThroughPageVC"
        }
    }
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherService.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
        
        self.navigationItem.title = "Weather"
        
        weatherView.stopSpeech()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
         Display the walkthrough if application is opened for first time
         */
        if displayWalkThrough() {
            return
        }
        
        let userDefaults = UserDefaults.standard
        
        // Show weather for last selected city
        if let cityName = userDefaults.string(forKey: "SelectedCity") {
            weatherService.getWeather(cityName)
            weatherService.getCityImage(cityName)
            
            manager.stopUpdatingLocation()
        }
        // Else show weather of current location
        else {
            // if location service is enabled
            if CLLocationManager.locationServicesEnabled() {
                manager.delegate = self
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.distanceFilter = 1000.0
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
            }
        }
        
        // Set play icon if bool is false
        if !userDefaults.bool(forKey: "isPlay") {
            playStopBarButton.image = #imageLiteral(resourceName: "stop")
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
    
    // MARK: Walk Through
    
    private func displayWalkThrough() -> Bool {
        let userDefaults = UserDefaults.standard
        let isWalkThroughShown = userDefaults.bool(forKey: Constants.AppConstants.kIsWalkThroughShown)
        
        if !isWalkThroughShown {
            if let pageVC = storyboard?.instantiateViewController(withIdentifier: Constants.SegueIdentifiers.WalkThroughPageVCID) {
                self.present(pageVC, animated: true, completion: nil)
                return true
            }
            return false
        }
        return false
    }
    
    // MARK: Weather Service Delegate
    
    func setWeather(_ weather: WeatherModel) {
        
        self.navigationItem.title = weather.cityName
        
        selectedWeather = weather
        weatherView.displayWeatherInfo(weather: weather, isForecast: false)
    }
    
    func setWeatherForecast(_ weathers: [WeatherModel]) {
        /*
         Empty as not required to be implemented here
         */
    }
    
    func setCityImage(_ cityImageURL: URL?) {
        weatherView.displayCityImage(cityImageURL: cityImageURL)
    }
    
    // MARK: Mute Speech
    
    @IBAction func stopOrPlaySpeech() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isPlay") {
            userDefaults.set(false, forKey: "isPlay")
            weatherView.stopSpeech()
            playStopBarButton.image = #imageLiteral(resourceName: "stop")
        }
        else {
            userDefaults.set(true, forKey: "isPlay")
            playStopBarButton.image = #imageLiteral(resourceName: "play")
        }
    }
    
    // MARK: Social Share
    
    @IBAction private func shareTapped(_ sender: Any) {
        let actionSheet = UIAlertController(title: Constants.ActionConstants.ActionShareTitle, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let shareMessageString = String(format:Constants.ActionConstants.ActionShareMessage, selectedWeather!.cityName, selectedWeather!.description, selectedWeather!.temp)
        
        // Configure a new action for sharing the note in Twitter.
        let tweetAction = UIAlertAction(title: Constants.ActionConstants.ActionTwitterTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            // Check if sharing to Twitter is possible.
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                if let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                    twitterComposeVC.setInitialText(shareMessageString)
                    
                    self.present(twitterComposeVC, animated: true, completion: nil)
                }
            }
            else {
                Helper.showAlertMessage(message: Constants.AlertConstants.AlertTwitterErrorMessage, sender: self)
            }
        }
        
        // Configure a new action to share on Facebook.
        let facebookPostAction = UIAlertAction(title: Constants.ActionConstants.ActionFBTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                if let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                    
                    facebookComposeVC.setInitialText(shareMessageString)
                    
                    self.present(facebookComposeVC, animated: true, completion: nil)
                }
            }
            else {
                Helper.showAlertMessage(message: Constants.AlertConstants.AlertFBErrorMessage, sender: self)
            }
        }
        
        // Configure a new action to show the UIActivityViewController
        let moreAction = UIAlertAction(title: Constants.ActionConstants.ActionMoreTitle, style: UIAlertActionStyle.default) { (action) -> Void in
            let activityViewController = UIActivityViewController(activityItems: [shareMessageString], applicationActivities: nil)
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        let dismissAction = UIAlertAction(title: Constants.ActionConstants.ActionCloseTitle, style: UIAlertActionStyle.cancel) { (action) -> Void in
        }
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookPostAction)
        actionSheet.addAction(moreAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.WeatherDetailSegueID {
            let weatherDetailTVC = segue.destination as! WeatherDetailTableViewController
            weatherDetailTVC.weather = selectedWeather
        }
        else if segue.identifier == Constants.SegueIdentifiers.ForecastSegueID {
            let forecastPageVC = segue.destination as! ForecastPageViewController
            forecastPageVC.cityName = selectedWeather?.cityName
            forecastPageVC.selectedCityImage = weatherView.cityImageView.image
        }
    }
    
    // MARK: Navigation
    
    @IBAction func unwindToWeather(_ sender: UIStoryboardSegue) {
        if sender.identifier == Constants.SegueIdentifiers.UnwindWeatherSegueID {
            let userDefaults = UserDefaults.standard
            if let cityName = userDefaults.string(forKey: "SelectedCity") {
                weatherService.getWeather(cityName)
            }
        }
    }
    
    // MARK: CLLocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .restricted, .denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified, please open the app's settings and set location access to 'Always'.",
                preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            Helper.getAddressFor(location: currentLocation, completionHandler: {(city) -> Void in
                self.navigationItem.title = city
                self.weatherService.getWeather(city)
                if !City.saveCity(city: City(name: city)!) {
                    Helper.showAlertMessage(message: "Not able to save city", sender: self)
                    return
                }
                let userDefaults = UserDefaults.standard
                userDefaults.set(city, forKey: "SelectedCity")
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
