//
//  WeatherDetailTableViewCell.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//

import UIKit

class WeatherDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var windspeedlbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var ctynamelbl: UILabel!
    

    func setup(data: WeatherCoreData) {
        windspeedlbl.text = "Wind: \(data.windspd ?? "")"
        humidityLbl.text = "Humidity: \(data.humiditylvl ?? "")"
        tempLbl.text = "Temp: \(data.temp ?? "")"
        timeLbl.text = "Time: \(data.time ?? "")"
        dateLbl.text = data.crntdate ?? ""
        fromLbl.text = data.fromhist ?? ""
        ctynamelbl.text = data.ctyname ?? ""
    }
}
