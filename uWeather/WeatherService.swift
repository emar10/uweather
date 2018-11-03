//
//  WeatherService.swift
//  uWeather
//
//  Created by Ethan Martin on 11/3/18.
//  Copyright © 2018 Ethan Martin. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherServiceDelegate {
    func didGetWeatherInfo(jsonData: Any)
    func didFail(withError: Error)
}

class WeatherService : NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    let host = "https://api.darksky.net"
    let path = "forecast"
    let api = "changeme"
    
    var delegate: WeatherServiceDelegate?
    
    func update() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getWeatherInfo(location: CLLocation) {
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        let url = URL(string: "\(host)/\(path)/\(api)/\(lat),\(long)")!
        let urlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        print("Trying to request weather with URL : \(url)")
        
        let task = urlSession.dataTask(with: url, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                print("Failed")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                print("Failed, bad JSON")
                return
            }
            
            print(json)
            self.delegate?.didGetWeatherInfo(jsonData: json)
        })
        
        task.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error!: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            print("Got hit!: \(currentLocation)")
            getWeatherInfo(location: currentLocation)
        }
    }
}
