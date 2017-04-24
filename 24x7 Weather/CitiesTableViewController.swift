//
//  CitiesTableViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 20/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    var cities = [City]()
    
    struct Constants {
        static let CustomCellIdentifier = "CityCell"
        
        static let CellRowHeight: CGFloat = 72.0
    }
    
    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedCities = City.getCities() {
            cities += savedCities
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set custom back button
        self.navigationItem.hidesBackButton = true
        let backImage = #imageLiteral(resourceName: "back_icon")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButton))
    }
    
    func backButton() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellIdentifier, for: indexPath)
        let city1 = cities[indexPath.row]
        cell.textLabel?.text = city1.cityName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cityName = cities[indexPath.row].cityName {
            let userDefaults = UserDefaults.standard
            userDefaults.set(cityName, forKey: "SelectedCity")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.CellRowHeight
    }
    
    // MARK:
    
    @IBAction func unwindToCityList(_ sender: UIStoryboardSegue) {
        /*
         Insert the new city at the bottom of the tableView
         Note: Not reloading the whole tableView
         */
        if sender.identifier == "unwindToCities" {
            if let savedCities = City.getCities() {
                cities = savedCities
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: cities.count-1, section: 0)], with: .automatic)
                tableView.endUpdates()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let city = cities[indexPath.row]
            if City.removeCity(city: city) {
                cities.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            else {
                Helper.showAlertMessage(message: "Oops! Could not remove the city", sender: self)
            }
        }
    }
}
