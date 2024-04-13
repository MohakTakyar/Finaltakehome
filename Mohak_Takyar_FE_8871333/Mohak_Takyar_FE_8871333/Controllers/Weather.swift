//
//  Weather.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//

import UIKit

class Weather: UIViewController {

    @IBOutlet weak var wetherImg: UIImageView!
    @IBOutlet weak var humidityLevel: UILabel!
    @IBOutlet weak var temperaturee: UILabel!
    @IBOutlet weak var descrip: UILabel!
    @IBOutlet weak var MycityName: UILabel!
    @IBOutlet weak var windspeedlbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.title = "Weather"
        fetchWeatherData(for: "Waterloo")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBttnTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBttnTapped() {
        showCityInputAlert(on: self, title: "Enter City Name", message: "Please enter the name of the city:") { [weak self] cityName in
            self?.fetchWeatherData(for: cityName)
        }
    }
    
    
    
    private func fetchWeatherData(for city: String) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=debc0757dd7272a17a9927ab2cda88b7&units=metric") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching weather data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(WeatherModel.self, from: data)
                DispatchQueue.main.async {
                    self?.updateUI(with: weatherData)
                }
            } catch {
                print("Error decoding weather data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func Weather(data: WeatherModel) {
        DataSavingManager.shared.saveWeather(cityName: data.name,
                                date: Date.getCurrentDate(),
                                humidity: "\(data.main.humidity)%",
                                temp: "\(Int(data.main.temp))°C",
                                time: Date().currentTime(),
                                wind: "\(data.wind.speed) km/h")
    }
    
    private func updateUI(with weatherData: WeatherModel) {
        MycityName.text = weatherData.name
        descrip.text = weatherData.weather.first?.description ?? "N/A"
        temperaturee.text = "\(Int(weatherData.main.temp))°C"
        humidityLevel.text = "Humidity: \(weatherData.main.humidity)%"
        windspeedlbl.text = "Wind: \(weatherData.wind.speed) km/h"
        
        Weather(data: weatherData)
    }
}
