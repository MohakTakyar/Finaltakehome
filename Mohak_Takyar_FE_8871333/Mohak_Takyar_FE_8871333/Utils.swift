//
//  Utils.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//

import UIKit

enum SaveData: String {
    case directions = "DirectionsData"
    case news = "NewsData"
    case weather = "WeatherCoreData"
}

func showCityInputAlert(on viewController: UIViewController, 
                        title: String, 
                        message: String,
                        callback: @escaping (String) -> Void) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addTextField { textField in
        textField.placeholder = "City name"
    }
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        if let textField = alertController.textFields?.first, let cityName = textField.text {
            callback(cityName)
        }
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    viewController.present(alertController, animated: true)
}

func mapWeatherConditionToSymbol(_ id: Int) -> String {
    switch id {
    case 200...232: return "cloud.bolt.rain.fill"
    case 300...321: return "cloud.drizzle.fill"
    case 500...531: return "cloud.rain.fill"
    case 600...622: return "cloud.snow.fill"
    case 701...781: return "cloud.fog.fill"
    case 800: return "sun.max.fill"
    case 801...804: return "cloud.fill"
    default: return "questionmark.circle"
    }
}

extension UIViewController {
    var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
   }
}

extension Date {
    static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
    
    func currentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
