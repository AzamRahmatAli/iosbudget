//
//  QuickSummaryViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/25/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class QuickSummaryViewController: UIViewController {


    var timePeriod : [String] = []
    var incomeTotal : [Float] = []
    var expenseTotal : [Float] = []
    var addMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if addMenu
        {
            Helper.addMenuButton(self)
        }

       for index in 0...3
            {
                expenseTotal.append(getExpenses(index))
                incomeTotal.append(getIncome(index))
                timePeriod.append(getDateSting(index))
                
        }
    }
    
    func dismis()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
 

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return timePeriod.count
    }
    
    func getDatesOfRange(index : Int) -> (startDate : NSDate, endDate : NSDate)
    {
       
        if index == 0
        {
            return NSDate().getDatesOfRange(.Day)
            
        }
        else if index == 1
        {
            return NSDate().getDatesOfRange(.WeekOfYear)
            
        }
        else if index == 2
        {
            return NSDate().getDatesOfRange(.Month)
           
          
        }
        else if index == 3
        {
            return NSDate().getDatesOfRange(.Year)
            
            
        }
        
        return (NSDate(), NSDate())
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ParentTableViewCell
        
        cell.leftUp.text = timePeriod[indexPath.row]
        
        cell.rightUp.text = incomeTotal[indexPath.row].asLocaleCurrency
        
        cell.rightDown.text = expenseTotal[indexPath.row].asLocaleCurrency
        
        return cell
        
    }
    
    func getDateSting(index : Int) -> String
    {
        let dateFormatter = NSDateFormatter()
        
        if index == 0
        {
            
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let selectedDate = dateFormatter.stringFromDate(NSDate())
            return "Day: \(selectedDate)"
        }
        else if index == 1
        {
            let (startDate, endDate) = getDatesOfRange(index)
            dateFormatter.dateFormat = "MMM dd"
            let start = dateFormatter.stringFromDate(startDate)
            
            let end = endDate.dateByAddingTimeInterval(-20 * 60 * 60) // because endDate is giving next day date
            let last = dateFormatter.stringFromDate(end)
            return "Week: \(start) - \(last)"
        }
        else if index == 2
        {
            dateFormatter.dateFormat = "MMMM yyyy"
            let selectedDate = dateFormatter.stringFromDate(NSDate())
            return "Month: \(selectedDate)"
            
        }
        else if index == 3
        {
            dateFormatter.dateFormat = "yyyy"
            let selectedDate = dateFormatter.stringFromDate(NSDate())
            return "Year: \(selectedDate)"
            
        }
        return ""
    }
    func getIncome(index : Int) -> Float
    {
     
        var income : Float = 0.0
        
        let (startDate, endDate) = getDatesOfRange(index)
        
        
        do{
            let request = NSFetchRequest(entityName: "IncomeTable")
            
            
            
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate, endDate)
            
            
            let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request) as! [IncomeTable]
            
            for element in queryResult
            {
                income += Float(element.amount ?? "0") ?? 0.0
                
            }
            
            
            
        }
        catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
           //print("error : ", error)
        }
        
        
        return income

    }
    
    func getExpenses(index : Int) -> Float
    {
        var expenses : Float = 0.0
        
        let (startDate, endDate) = getDatesOfRange(index)
        
        
        do{
            let request = NSFetchRequest(entityName: "ExpenseTable")
            
            
            
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate, endDate)
            
            
            let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
            
            for element in queryResult
            {
                expenses += Float(element.amount ?? "0") ?? 0.0
                
            }
            
        }
        catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
           //print("error : ", error)
        }
        
        
        return expenses
        
    }

    
    override func viewWillAppear(animated: Bool) {
        if addMenu
        {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
        
}


