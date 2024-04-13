//
//  NewsTableViewCell.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//

import UIKit

class NewsDataTableViewCell: UITableViewCell {

    @IBOutlet weak var athrLbl: UILabel!
    @IBOutlet weak var srclbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var contantLbl: UILabel!
    @IBOutlet weak var ctyLbl: UILabel!
    
    func setupCell(data: NewsData) {
        athrLbl.text = "Author: \(data.athr ?? "")"
        srclbl.text = "Source: \(data.source ?? "")"
        titleLbl.text = "Title: \(data.title ?? "")"
        fromLbl.text = "From: \(data.fromhist ?? "")"
        contantLbl.text = "Content: \(data.contant ?? "")"
        ctyLbl.text = "City Name: \(data.ctyname ?? "")"
    }

}
