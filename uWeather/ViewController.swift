//
//  ViewController.swift
//  uWeather
//
//  Created by Ethan Martin on 11/3/18.
//  Copyright © 2018 Ethan Martin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @objc var weatherModel = WeatherModel()
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var weatherModelObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherModelObservation = observe(\.weatherModel.updates) { object, change in
            print("updating display")
            DispatchQueue.main.async(execute: { self.updateView() })
        }
        
        weatherModel.updateWeather()
    }
    
    func updateView() {
        summaryLabel.text = weatherModel.summary
        tempLabel.text = "\(weatherModel.temperature)°"
        locationLabel.text = weatherModel.location
        iconImageView.image = UIImage(named: weatherModel.icon)
    }
}

