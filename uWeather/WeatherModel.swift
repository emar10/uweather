//
//  WeatherModel.swift
//  uWeather
//
//  Created by Ethan Martin on 11/4/18.
//  Copyright © 2018 Ethan Martin. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherModel: NSObject, WeatherServiceDelegate {
    let weatherService = WeatherService()
    
    @objc dynamic var location: String
    @objc dynamic var icon: String
    @objc dynamic var summary: String
    @objc dynamic var temperature: Int
    @objc dynamic var updates: Int
    
    override init() {
        location = "Loading weather..."
        icon = ""
        summary = ""
        temperature = 0
        updates = 0
        
        super.init()
    }
    
    func updateWeather() {
        weatherService.delegate = self
        weatherService.update()
    }
    
    func weatherService(didUpdateLocation location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            let locationError = "Unknown Location"
            if error == nil {
                let placemark = placemarks?[0]
                if let city = placemark?.locality {
                    self.location = city
                } else {
                    self.location = locationError
                }
            } else {
                print(error!)
                self.location = locationError
            }
        })
    }
    
    func weatherService(didUpdateWeather jsonData: Any) {
        if let root = jsonData as? [String: Any] {
            if let current = root["currently"] as? [String: Any] {
                if let cicon = current["icon"] as? String {
                    self.icon = cicon
                }
                
                if let csummary = current["summary"] as? String {
                    self.summary = csummary
                }
                
                if let ctemperature = current["temperature"] as? Double {
                    self.temperature = Int(ctemperature)
                }
            }
        }
        
        DispatchQueue.main.async(execute: { self.updates += 1 } )
    }
    
    func weatherService(didFailWithError error: Error) {
        location = "Error retrieving weather!"
    }
}
