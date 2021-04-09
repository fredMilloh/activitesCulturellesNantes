//
//  DetailInfosTableViewCell.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit

class DetailInfosTableViewCell: UITableViewCell {
    
    @IBOutlet var grayView: UIView!
    @IBOutlet var titreLabel: UILabel!
    @IBOutlet var texteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        grayView.layer.cornerRadius = 10
        addShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func addShadow() {
        grayView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
        grayView.layer.shadowRadius = 2.0
        grayView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        grayView.layer.shadowOpacity = 2.0
    }
}
        