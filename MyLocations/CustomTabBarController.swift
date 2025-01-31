//
//  CustomTabBarController.swift
//  MyLocations
//
//  Created by G. Kotiyala on 4/8/15.
//  Copyright (c) 2015 mwsu. All rights reserved.
//

import Foundation

import UIKit
// This class holds the data for my model.
class ModelData {
    var latitude = 0.0
    var longitude = 0.0
}

class CustomTabBarController: UITabBarController {
    
    // Instantiate the one copy of the model data that will be accessed
    // by all of the tabs.
    
    var model = ModelData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}
