//
//  Main.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//

import UIKit
import MapKit

class Main: UIViewController, MKMapViewDelegate, UITabBarDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var Mymapview: MKMapView!
    
    @IBOutlet weak var Templevel: UILabel!
    
    @IBOutlet weak var Windspeed: UILabel!
    @IBOutlet weak var Humiditylevel: UILabel!
    
    @IBOutlet weak var weatherimg: UIImageView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "My Final", style: .plain, target: nil, action: nil)
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        Mymapview.delegate = self
        Mymapview.showsUserLocation = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender as? UIButton else { return }
        if sender.tag == 2 {
            if let destination = segue.destination as? UITabBarController {
                destination.selectedIndex = 1
            }
        } else if sender.tag == 3 {
            if let destination = segue.destination as? UITabBarController {
                destination.selectedIndex = 2
            }
        }
    }
    
    func updateUI(with data: WeatherModel) {
        Templevel.text = "\(Int(data.main.temp))°C"
        Windspeed.text = "Wind: \(data.wind.speed)Km/h"
        Humiditylevel.text = "Humidity: \(data.main.humidity)"
        weatherimg.image = UIImage(systemName: mapWeatherConditionToSymbol(data.weather.first?.id ?? 0))
    }
    func navigationController(_ navcntroler: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let hide = (viewController is Main)
        navcntroler.setNavigationBarHidden(hide, animated: animated)
    }
    func locationManager(_ mnger: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            mnger.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        Mymapview.setRegion(region, animated: true)
        fetchWeatherData(for: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error.localizedDescription)")
    }
    
    private func fetchWeatherData(for coordinate: CLLocationCoordinate2D) {
        let apiKey = "debc0757dd7272a17a9927ab2cda88b7" 
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(apiKey)&units=metric")!
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherModel.self, from: data)
                
                DispatchQueue.main.async {
                    self?.updateUI(with: weatherData)
                }
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
}
