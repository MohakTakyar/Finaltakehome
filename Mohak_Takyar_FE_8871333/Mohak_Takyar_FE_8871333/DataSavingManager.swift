//
//  DataSavingManager.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 08/04/24.
//

import UIKit
import CoreData

class DataSavingManager {
    static let shared = DataSavingManager()
    
    private init() {}
    func saveDirection(ctyname: String, distence: String, fromhist: String, method: String, strtPnt: String, endPnt: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let direction = DirectionsData(context: context)
        direction.ctyname = ctyname
        direction.distence = distence
        direction.fromhist = fromhist
        direction.method = method
        direction.datatyp = SaveData.directions.rawValue
        direction.strtPnt = strtPnt
        direction.endPnt = endPnt
        do {
            try context.save()
        } catch {
            print("Failed to save direction: \(error.localizedDescription)")
        }
    }

    func saveNews(athr: String, ctyname: String, contant: String, fromhist: String, source: String, title: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let news = NewsData(context: context)
        news.athr = athr
        news.ctyname = ctyname
        news.contant = contant
        news.fromhist = fromhist
        news.source = source
        news.title = title
        news.datatyp = SaveData.news.rawValue

        do {
            try context.save()
        } catch {
            print("Failed to save news: \(error.localizedDescription)")
        }
    }

    func saveWeather(cityName: String, date: String, humidity: String, temp: String, time: String, wind: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let weather = WeatherCoreData(context: context)
        weather.ctyname = cityName
        weather.crntdate = date
        weather.humiditylvl = humidity
        weather.temp = temp
        weather.time = time
        weather.windspd = wind
        weather.datatyp = SaveData.weather.rawValue
        
        do {
            try context.save()
        } catch {
            print("Failed to save weather: \(error.localizedDescription)")
        }
    }
    
    func firstCheckMethod() {
        let defaults = UserDefaults.standard
        if !defaults.bool(forKey: "firstLaunch") {
            defaults.set(true, forKey: "firstLaunch")
            defaults.synchronize()
            let cities = ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix"]
            for city in cities {
                saveNews(athr: "Anonymous", ctyname: city, contant: "Sample news content", fromhist: "Local News", source: "Sample Source", title: "Sample News Title")
            }
        }
    }
}
