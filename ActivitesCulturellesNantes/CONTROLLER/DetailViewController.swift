//
//  DetailViewController.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: HeaderDetailView!
    
    var detailMedia = ""
    var detailNom = ""
    var detailDate = ""
    var detailHeureDebut = ""
    var detailHeureFin = ""
    var detailLieu = ""
    var detailAdresse = ""
    var detailVille = ""
    var detailInfoSup = ""
    var detailDescription = ""
    var detailPrecisionsTarif = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        //Configuration headerView
        headerView.dateLabel.text = (detailDate + "   " + detailHeureDebut)
        headerView.nomLabel.text = detailNom
        headerView.headerImage.downloadedImage(from: detailMedia)
    }
    
}
 
extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailDescriptionCell", for: indexPath) as! DetailDescriptionTableViewCell
            cell.lieuLabel.text = detailLieu
            cell.adresseLabel.text = detailAdresse
            cell.villeLabel.text = detailVille
            cell.descriptionLabel.text = detailDescription
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfosCell", for: indexPath) as! DetailInfosTableViewCell
            cell.titreLabel.text = "Date et Horaire"
            
            if detailInfoSup == "" {
                cell.texteLabel.text = detailHeureDebut == "" ? detailDate : (detailDate + " de " + detailHeureDebut + " à " + detailHeureFin)
            } else { cell.texteLabel.text = detailInfoSup }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfosCell", for: indexPath) as! DetailInfosTableViewCell
            if detailPrecisionsTarif == "" {
                cell.isHidden = true
            } else {
                cell.titreLabel.text = "Moyens de Paiement"
                cell.texteLabel.text = detailPrecisionsTarif
            }
            return cell
            
        default:
            fatalError("Echec")
        }
    }
    
}
extension UIImageView {
    func downloadedImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
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
    func downloadedImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
   
    

    

