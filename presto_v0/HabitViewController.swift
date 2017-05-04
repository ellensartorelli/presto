//
//  HabitViewController.swift
//  HabitTracker
//
//  Created by Joy A Wood on 4/26/17.
//  Copyright © 2017 Joy A Wood. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HabitViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    var habit: Habit?
    
    var selected = [Date]()
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        navigationItem.title = habit?.name
        if(habit != nil){
            selected = (habit?.selectedDates)!
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        //        guard let button = sender as? UIBarButtonItem, button === saveButton else {
        //            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
        //            return
        //        }
        
        
        
        // Set the habit to be passed to MealTableViewController after the unwind segue.
        
    }
    
    
    
    
    func setupCalendarView(){
        calendarView.minimumLineSpacing=0
        calendarView.minimumInteritemSpacing=0
        
        //setup labels
        calendarView.visibleDates{(visibleDates) in
            let date = visibleDates.monthDates.first!.date
            self.formatter.dateFormat = "yyyy"
            self.year.text = self.formatter.string(from: date)
            self.formatter.dateFormat = "MMMM"
            self.month.text = self.formatter.string(from: date)
        }
    }
    
    func handleTextColor(view: JTAppleCell?, cellState: CellState ){
        guard let validCell = view as? CustomCell else{
            return
        }
        if(cellState.date>Date()){
            validCell.dateLabel.textColor = UIColor.lightGray
        }
        else{
            validCell.dateLabel.textColor = UIColor.blue
            
        }
    }
    
}

extension HabitViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        guard let startDate = habit?.startDate else{
            fatalError("doing it like this was a terrible idea")}
        guard let endDate = habit?.endDate else{
            fatalError("doing it like this was a terrible idea")}
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
        
    }
    
    
    
}

extension HabitViewController: JTAppleCalendarViewDelegate{
    //Display the Cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell{
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        handleTextColor(view: cell, cellState: cellState)
        cell.dateLabel.text = cellState.text
        if(selected.contains(cellState.date)){
            cell.selectedView.isHidden = false
        }
        else{
            cell.selectedView.isHidden = true
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else{
            return
        }
        
        if(cellState.date<Date()){
            if(validCell.selectedView.isHidden){
                selected.append(cellState.date)
                validCell.selectedView.isHidden = false
            }
            else{
                validCell.selectedView.isHidden = true
                if let index = selected.index(of: cellState.date) {
                    selected.remove(at: index)
                }
            }
        }
        
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    //deselect function not in use/ simulating toggle functionality
    
    /*    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
     guard let validCell = cell as? CustomCell else{
     return
     }
     validCell.selectedView.isHidden = validCell.selectedView.isHidden
     
     }
     */
    
}
