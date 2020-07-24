//
//  EventsListViewController.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit

class EventsListViewController: UIViewController {

        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var calendarButton: UIButton!
        @IBOutlet weak var dateLabel: UILabel!
        
        private static var array = [records]()

        override func viewDidLoad() {
            super.viewDidLoad()
            addCircleButton()
            // rendre navbar transparente pour image occupe tout le haut
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            currentEvents()
        }
        
        func currentEvents() {
            QueryListService.shared.get { (result) in
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
            
            cell.configure(nom: event.fields.nom, media: event.fields.media_1 ?? "", date: "aujourd'hui", gratuit: gratuit, complet: complet)
            
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

