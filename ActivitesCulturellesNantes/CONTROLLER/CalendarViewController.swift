//
//  CalendarViewController.swift
//  ActivitesCulturellesNantes
//
//  Created by fred on 24/07/2020.
//  Copyright © 2020 fred. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    var calendar = FSCalendar()
    
    //date selected on calendar for request
    var dateSelected: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: calendar.selectedDate!)
    }
    // name of day
    var stringDay: String {
        let formatterDate = DateFormatter()
        formatterDate.locale = Locale(identifier: "fr_FR")
        formatterDate.dateFormat = "EEEE dd MMMM"
        return formatterDate.string(from: calendar.selectedDate!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // put calendar on view
        calendar.frame = CGRect(x: 0, y: 100, width: view.frame.size.width, height: 250)
        calendar.backgroundColor = .white
        let locale = NSLocale(localeIdentifier: "fr_FR")
        calendar.locale = locale as Locale
        view.addSubview(calendar)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
