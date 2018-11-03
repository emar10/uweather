//
//  ViewController.swift
//  uWeather
//
//  Created by Ethan Martin on 11/3/18.
//  Copyright © 2018 Ethan Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherService.update()
    }
}

