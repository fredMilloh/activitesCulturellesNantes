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
            addCircleButton()
            // rendre navbar transparente pour image occupe tout le haut
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            currentEvents(date: EventsListViewController.currentDate)
        }
        
    func currentEvents(date: String) {
            QueryListService.shared.get(dateSelected: date) { (result) in
                switch result {
                case .failure(let error) :
                    print(error)
                case .success(let eventsData) :
                    print(eventsData)
                    self.update(with: eventsData.records)
                }
            }
        }
        
        private func update(with events: [records]) {
            
            EventsListViewController.array = events
            
            let nomSorted = events.sorted(by: {$0.fields.id_manif < $1.fields.id_manif})
            EventsListViewController.array = nomSorted
            
            tableView.reloadData()
        }
        
        func addCircleButton() {
            calendarButton.layer.borderWidth = 1
            calendarButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            calendarButton.layer.cornerRadius = 15
        }
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
        }
    }
    
}

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
extension EventsListViewController: UITableViewDelegate {
    
        // swippe droit avec action supprimer et partager
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let supprimerAction = UIContextualAction(style: .destructive, title: "supprimer") { (action, sourceView, completionHandler) in
                EventsListViewController.array.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
            
            let partagerAction = UIContextualAction(style: .normal, title: "partager") { (action, sourceView, completionHandler) in
                let textParDefaut = "Aller à cet événement" + EventsListViewController.array[indexPath.row].fields.nom
                let activityController = UIActivityViewController(activityItems: [textParDefaut], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
                completionHandler(true)
            }
            
            let swippeConfiguration = UISwipeActionsConfiguration(actions: [supprimerAction, partagerAction])
            return swippeConfiguration
        }
    }

