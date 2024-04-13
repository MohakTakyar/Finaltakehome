//
//  DirectionsTableViewCell.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//
import UIKit

class DirectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var ctyNamelbl: UILabel!
    @IBOutlet weak var dstTravelled: UILabel!
    @IBOutlet weak var modeOfTavel: UILabel!
    @IBOutlet weak var endLbl: UILabel!
    @IBOutlet weak var strtlbl: UILabel!
    
    func setup(data: DirectionsData) {
        ctyNamelbl.text = data.ctyname ?? ""
        dstTravelled.text = data.distence ?? ""
        modeOfTavel.text = data.method
        endLbl.text = data.endPnt ?? ""
        strtlbl.text = data.strtPnt ?? ""
    }
}
