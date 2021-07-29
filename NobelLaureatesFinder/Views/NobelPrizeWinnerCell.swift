//
//  NobelPrizeWinnerCell.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/29/21.
//

import UIKit

class NobelPrizeWinnerCell: UITableViewCell {

    var laureate: Laureate? {
        didSet {
            laureateName.text = "\(laureate?.firstName ?? "") \(laureate?.surname ?? "")"
            institutionName.text = laureate?.name
            dateAndLocation.text = "\(laureate?.year.description ?? "") - \(laureate?.city ?? ""), \(laureate?.country ?? "")"
        }
    }
    
    @IBOutlet weak var laureateName: UILabel!
    @IBOutlet weak var institutionName: UILabel!
    @IBOutlet weak var dateAndLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
