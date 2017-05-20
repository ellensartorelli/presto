//
//  HabitViewController.swift
//  HabitTracker
//
//  Created by Joy A Wood on 4/26/17.
//  Copyright © 2017 Joy A Wood. All rights reserved.
//

import UIKit
import JTAppleCalendar
import os.log

class HabitViewController: UIViewController {
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var habitName: UINavigationItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var habit: Habit?
    
    var selected = [Date]()
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        habitName.title = habit?.name
        if(habit != nil){
            selected = (habit?.selectedDates)!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation
    
    // This method lets you configure a view controller before it's presented.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        habit?.selectedDates = selected
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
            if (!validCell.selectedView.isHidden){
                validCell.dateLabel.textColor = UIColor.white

            }
            else{
                let purple:UIColor = UIColorFromRGB(rgbValue: 4141376)
                validCell.dateLabel.textColor = purple
            }
        }
    }
    
}


extension HabitViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        guard let startDate = habit?.startDate else{
            //later replace with defaults
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
        cell.dateLabel.text = cellState.text
        if(selected.contains(cellState.date)){
            cell.selectedView.isHidden = false
        }
        else{
            cell.selectedView.isHidden = true
        }
        handleTextColor(view: cell, cellState: cellState)
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
        handleTextColor(view: cell, cellState: cellState)


        
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }

    
    //MARK: - setting color
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
}
