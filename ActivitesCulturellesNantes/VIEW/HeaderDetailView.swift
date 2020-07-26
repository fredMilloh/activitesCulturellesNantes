//
//  HeaderDetailView.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit

class HeaderDetailView: UIView {
    
    @IBOutlet var headerImage: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nomLabel: UILabel! {
        didSet {
            nomLabel.numberOfLines = 0
        }
    }


}


