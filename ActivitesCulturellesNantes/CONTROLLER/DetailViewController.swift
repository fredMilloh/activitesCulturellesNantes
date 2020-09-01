//
//  DetailViewController.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit
import MessageUI

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
    var detailLocation = ""
    var detailInfoSup = ""
    static var infoSup = ""
    var detailDescription = ""
    static var eventDescription = ""
    var detailPrecisionsTarif = ""
    static var eventTarif = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailViewController.eventDescription = ""
        DetailViewController.infoSup = ""
        DetailViewController.eventTarif = ""
        
        tableView.dataSource = self
        tableView.delegate = self
        //Configuration headerView
        headerView.dateLabel.text = (detailDate + "   " + detailHeureDebut)
        headerView.nomLabel.text = detailNom
        headerView.headerImage.downloadedImage(from: detailMedia)
        
        print("brutDescription", detailDescription)
        print("brutInfos", detailInfoSup)
        print("brutTarif", detailPrecisionsTarif)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapView" {
            let destinationController = segue.destination as! MapViewController
            destinationController.mapNom = detailNom
            destinationController.mapLocation = detailLocation
        }
    }
    
// mail button with extension MFMail...Delegate
    @IBAction func sendMail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["destinataire"])
            mail.setSubject("Sortie Culturelle")
            mail.setMessageBody(("Hello there, are you interested by this event." + "\n" + detailNom + "\n" + detailLieu + "\n" + DetailViewController.eventDescription), isHTML: false)
                present(mail, animated: true)
            } else {
                print("cannot send mail")
            }
    }
    
    // pour afficher une phrase par ligne
    func descriptionStyle(texte: String) {
        let description = texte
        let results = description.components(separatedBy: "  ")
        for result in results {
            DetailViewController.eventDescription += "\n" + result
        }
    }
    // avec extensions sequence et string
    func infoStyle(texte: String) {
        let infos = texte.splitBefore(separator: { $0.isUppercase }).map{String($0)}
        for info in infos {
            DetailViewController.infoSup += info + "\n\n"
        }
    }
    func tarifStyle(texte: String) {
        let line = texte
        let tarifs = line.components(separatedBy: "  ")
        //let tarifs = line.splitBefore(separator: { $0.isNumber })
        for tarif in tarifs {
            DetailViewController.eventTarif += tarif + "\n"
        }
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
            cell.nom = detailNom
            cell.lieuLabel.text = detailLieu
            cell.adresseLabel.text = detailAdresse
            cell.villeLabel.text = detailVille
            
            descriptionStyle(texte: detailDescription)
            cell.descriptionLabel.text = DetailViewController.eventDescription
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfosCell", for: indexPath) as! DetailInfosTableViewCell
            cell.titreLabel.text = "Date et Horaire"
            
            if detailInfoSup == "" {
                cell.texteLabel.text = detailHeureDebut == "" ? detailDate : (detailDate + " de " + detailHeureDebut + " à " + detailHeureFin)
            } else {
                infoStyle(texte: detailInfoSup)
                cell.texteLabel.text = DetailViewController.infoSup
            }
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailInfosCell", for: indexPath) as! DetailInfosTableViewCell
            if detailPrecisionsTarif == "" {
                cell.isHidden = true
            } else {
                cell.titreLabel.text = "Moyens de Paiement"
                tarifStyle(texte: detailPrecisionsTarif)
                cell.texteLabel.text = DetailViewController.eventTarif
                print("eventTarif", DetailViewController.eventTarif)
            }
            return cell
            
        default:
            fatalError("Echec")
        }
    }
    
}

extension DetailViewController: UITableViewDelegate {
 // cell animated
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // position cell au départ et définition animation (ici rotation 90° vers gauche)
        /*
        let rotationAngleRadians = 90.0 * CGFloat(Double.pi/180.0)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleRadians, 0, 0, 1)
        */
        // arrivée cell par le bas à droite
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 100, 0)
        cell.layer.transform = rotationTransform
        // durée animation et position final (Identity pour position par défaut des cell)
        UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})
    }
}

// to active cancel button etc...
extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            dismiss(animated: true)
        }
        
        switch result {
        case .cancelled :
            print("cancelled")
        case .failed :
            print("failed")
        case .saved :
            print("saved")
        case .sent :
            print("sent")
        @unknown default:
            fatalError()
        }
        dismiss(animated: true)
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

extension Sequence { // pour func infoStyle
       func splitBefore(separator isSeparator: (Iterator.Element) throws -> Bool) rethrows -> [AnySequence<Iterator.Element>] {
           var result: [AnySequence<Iterator.Element>] = []
           var subSequence: [Iterator.Element] = []

           var iterator = self.makeIterator()
           while let element = iterator.next() {
               if try isSeparator(element) {
                if !subSequence.isEmpty {
                       result.append(AnySequence(subSequence))
                   }
                   subSequence = [element]
               }
               else {
                   subSequence.append(element)
               }
           }
           result.append(AnySequence(subSequence))
           return result
       }
   }

extension String {  // pour func infoStyle

    var isLowercase: Bool {
        return self == self.lowercased()
    }

    var isUppercase: Bool {
        return self == self.uppercased()
    }
}
