//
//  WeatherDetailTableViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 20/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class WeatherDetailTableViewController: UITableViewController {
    
    var weather: WeatherModel! = nil
    
    var weatherDetails = ["Humidity", "Pressure", "Wind", "Cloud", "Rain", "Snow", "Sunrise", "Sunset", "Visibility"]
    var weatherDetailImages = ["humidity", "pressure", "wind", "cloud", "rain", "snow", "sunrise", "sunset", "visibility"]
    
    struct Constants {
        static let CustomCellIdentifier = "DetailCell"
        
        static let CellRowHeight: CGFloat = 72.0
        
        struct Measurement {
            static let PercentageSymbol = " %"
            static let PressureSymbol = " hPa"
            static let TempSymbol = "º C"
            static let VolumeSymbol = " mm"
            static let VisibilitySymbol = " m"
            static let WindSpeedSymbol = " m/s"
        }
    }
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = weather.cityName
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
    
    // MARK: Back BarButton
    
    func backButton() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherDetails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellIdentifier, for: indexPath)
        
        var title = ""
        var description = ""
        
        switch indexPath.row {
        case 0:
            title = weatherDetails[indexPath.row]
            description = weather.humidity + Constants.Measurement.PercentageSymbol
            break
        case 1:
            title = weatherDetails[indexPath.row]
            description = weather.pressure + Constants.Measurement.PressureSymbol
            break
        case 2:
            title = weatherDetails[indexPath.row]
            description = weather.windSpeed + Constants.Measurement.WindSpeedSymbol +
        " at " + weather.windDegree + Constants.Measurement.TempSymbol
            break
        case 3:
            title = weatherDetails[indexPath.row]
            description = weather.cloudiness + Constants.Measurement.PercentageSymbol
            break
        case 4:
            title = weatherDetails[indexPath.row]
            description = weather.rain + Constants.Measurement.VolumeSymbol
            break
        case 5:
            title = weatherDetails[indexPath.row]
            description = weather.snow + Constants.Measurement.VolumeSymbol
            break
        case 6:
            title = weatherDetails[indexPath.row]
            if let sunrise = Double(weather.sunriseTimeStamp)?.getDateStringFromUTC() {
                description = sunrise
            }
            break
        case 7:
            title = weatherDetails[indexPath.row]
            if let sunrise = Double(weather.sunsetTimeStamp)?.getDateStringFromUTC() {
                description = sunrise
            }
            break
        case 8:
            title = weatherDetails[indexPath.row]
            description = weather.visibility + Constants.Measurement.VisibilitySymbol
            break
        default:
            break
        }
        
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = description
        cell.imageView?.image = UIImage(named: weatherDetailImages[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.CellRowHeight
    }
}

/*
 Format the UTC timestamp to hour&minutes (hh:mm a)
 */
extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: date)
    }
}
