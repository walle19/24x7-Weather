//
//  WalkThroughModel.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 19/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class WalkThroughModel: NSObject {

    var index = 0
    var titleText: String?
    var imageNameText: String?
    var isLast: Bool = false
    
    convenience init(index: Int, title: String, imageName: String) {
        self.init()
        self.index = index
        self.titleText = title
        self.imageNameText = imageName
    }
}
