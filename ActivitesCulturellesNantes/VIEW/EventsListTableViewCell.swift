//
//  EventsListTableViewCell.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit

class EventsListTableViewCell: UITableViewCell {

 
     @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var imageMedia: UIImageView! 
     @IBOutlet weak var nomLabel: UILabel!
     @IBOutlet weak var dateLabel: UILabel!
     @IBOutlet weak var gratuitLabel: UILabel!
     @IBOutlet weak var completLabel: UILabel!
    
     override func awakeFromNib() {
         super.awakeFromNib()
        
         imageMedia.layer.cornerRadius = 22
         addShadow()
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)
     }
     
     private func addShadow() {
         whiteView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor
         whiteView.layer.shadowRadius = 2.0
         whiteView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
         whiteView.layer.shadowOpacity = 2.0
     }

     func configure(nom: String, media: String, date: String, gratuit: String, complet: String) {
         nomLabel.text = nom
        imageMedia.downloaded(from: media)
         dateLabel.text = date
         gratuitLabel.text = gratuit
         completLabel.text = complet
         
     }
 }
 extension UIImageView {
     func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
         contentMode = mode
         URLSession.shared.dataTask(with: url) { data, response, error in
             guard
                 let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                 let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                 let data = data, error == nil,
                 let image = UIImage(data: data)
                 else { return }
             DispatchQueue.main.async() {
                 self.image = image
             }
         }.resume()
     }
     func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
         guard let url = URL(string: link) else { return }
         downloaded(from: url, contentMode: mode)
     }
 }

