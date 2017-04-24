//
//  WalkThroughViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 18/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController {

    @IBOutlet weak var wtImageView: UIImageView!
    @IBOutlet weak var wtTitleLabel: UILabel!
    
    @IBOutlet weak var skipOrDoneButton: UIButton!
    
    var walkThroughModel: WalkThroughModel?
    
    private struct Constants {
        static let SkipTitle = "Skip"
        static let DoneTitle = "Done"
        static let isWalkThroughShown = "isWalkThroughShown"
    }
    
    // MARK: ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if walkThroughModel != nil {
            wtTitleLabel.text = walkThroughModel!.titleText
            wtImageView.image = UIImage(named: walkThroughModel!.imageNameText!)
            
            let title = (walkThroughModel!.isLast) ? Constants.DoneTitle : Constants.SkipTitle
            skipOrDoneButton.setTitle(title, for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Skip/Done Walk Through
    
    @IBAction private func skipWalkThrough(_ sender: UIButton) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: Constants.isWalkThroughShown)
        userDefaults.synchronize()
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
