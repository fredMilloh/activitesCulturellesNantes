//
//  EventsListViewController.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit
import FSCalendar

class EventsListViewController: UIViewController {

        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var calendarButton: UIButton!
        @IBOutlet weak var dateLabel: UILabel!
        
        private static var array = [records]()
    
        static var date = NSDate()
        // date for request events
        static var currentDate: String {
            let formatterDate = DateFormatter()
            formatterDate.locale = Locale(identifier: "fr_FR")
            formatterDate.dateFormat = "YYYY-MM-dd"
            return formatterDate.string(from: date as Date)
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // rendre navbar transparente pour image occupe tout le haut
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            currentEvents(date: EventsListViewController.currentDate)
            print("currentDate", EventsListViewController.currentDate)
        }
        
    func currentEvents(date: String) {
            QueryListService.shared.get(dateSelected: date) { (result) in
                switch result {
                case .failure(let error) :
                    print(error)
                case .success(let eventsData) :
                    self.update(with: eventsData.records)
                    print("brut", eventsData)
                }
            }
        }
        
        private func update(with events: [records]) {
            
            EventsListViewController.array = events
            // tri 
            let manifIdSorted = events.sorted(by: {$0.fields.id_manif < $1.fields.id_manif})
            EventsListViewController.array = manifIdSorted
            tableView.reloadData()
        }
 
//MARKS: - affichage du calendrier et gestion date selectionnée
    @IBAction func calendarButtonPressed(_ sender: UIButton) {
        // création et affichage du calendarVC en popup
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let calendarView = sb.instantiateViewController(identifier: "calendar") as? CalendarViewController {
        self.present(calendarView, animated: true, completion: nil)
        }
        // reception notification et affectation valeur date
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "saveDate"), object: nil, queue: OperationQueue.main) { (notification) in
            let dateVC = notification.object as! CalendarViewController
            
            self.dateLabel.text = dateVC.stringDay
            self.currentEvents(date: dateVC.dateSelected)
            self.tableView.reloadData()
        }
    }
    
}
//MARKS: - Definition liste et config cell
extension EventsListViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return EventsListViewController.array.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventsListTableViewCell else { return UITableViewCell() }
            let event = EventsListViewController.array[indexPath.row]
            
            let complet: String
            let gratuit: String
            if event.fields.complet == "non" { complet = "" } else { complet = "complet" }
            if event.fields.gratuit == "non" { gratuit = "" } else { gratuit = "gratuit" }
            
            cell.configure(nom: event.fields.nom, media: event.fields.media_1 ?? "", date: dateLabel.text ?? "", gratuit: gratuit, complet: complet)
            
            return cell
        }
        
    }
//MARKS: - SELECT cell et ENVOI en push
extension EventsListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail: DetailViewController = self.storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        let path = EventsListViewController.array[indexPath.row]
        detail.detailMedia = path.fields.media_1 ?? ""
        detail.detailDate = dateLabel.text ?? ""
        detail.detailHeureDebut = path.fields.heure_debut ?? ""
        detail.detailHeureFin = path.fields.heure_fin ?? ""
        detail.detailNom = path.fields.nom
        detail.detailLieu = path.fields.lieu ?? ""
        detail.detailAdresse = path.fields.adresse ?? ""
        detail.detailVille = path.fields.ville ?? ""
        detail.detailLocation = path.fields.location
        detail.detailDescription = path.fields.description
        detail.detailInfoSup = path.fields.info_suppl ?? ""
        detail.detailPrecisionsTarif = path.fields.precisions_tarifs ?? ""
        
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
//MARKS: - SWIPPE droit avec action supprimer et partager
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let supprimerAction = UIContextualAction(style: .destructive, title: "supprimer") { (action, sourceView, completionHandler) in
                EventsListViewController.array.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
            
            let partagerAction = UIContextualAction(style: .normal, title: "partager") { (action, sourceView, completionHandler) in
                let textParDefaut = "Bonjour," + "\n" + "es-tu intéressé pour aller à cet événement :" + "\n" + EventsListViewController.array[indexPath.row].fields.nom + " :" + "\n" + EventsListViewController.array[indexPath.row].fields.description
                // to share image if existe
                let activityController: UIActivityViewController
                if let shareImage = self.imageView {
                    activityController = UIActivityViewController(activityItems: [textParDefaut, shareImage], applicationActivities: nil)
                } else {
                    activityController = UIActivityViewController(activityItems: [textParDefaut], applicationActivities: nil)
                }
                
                self.present(activityController, animated: true, completion: nil)
                completionHandler(true)
            }
            
            let swippeConfiguration = UISwipeActionsConfiguration(actions: [supprimerAction, partagerAction])
            return swippeConfiguration
        }
    
}
