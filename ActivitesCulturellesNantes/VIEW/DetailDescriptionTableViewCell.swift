//
//  DetailDescriptionTableViewCell.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit

class DetailDescriptionTableViewCell: UITableViewCell {
    
    @IBOutlet var whiteView: UIView!
    @IBOutlet var lieuLabel: UILabel!
    @IBOutlet var adresseLabel: UILabel!
    @IBOutlet var villeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func addShadow() {
        whiteView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        whiteView.layer.shadowRadius = 2.0
        whiteView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        whiteView.layer.shadowOpacity = 2.0
    }
}
