//
//  ExpenseViewController.swift
//  budget
//
//  Created by Azam Rahmat on 7/27/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class ExpenseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    
    var expenseMonthDate = NSDate()
    
    var expenseData : [String:AnyObject]?
    
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var expenseDataForSection : [ExpenseTable]?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var add: UIBarButtonItem!
    
    @IBOutlet weak var next: UIButton!
    @IBOutlet weak var prev: UIButton!
    @IBOutlet weak var expenseTotalLabel: UILabel!
    @IBOutlet weak var titleMonth: UILabel!
    @IBAction func addExpense(sender: AnyObject) {
        self.performSegueWithIdentifier("addExpense", sender: nil)
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add.tintColor = Helper.colors[0]
        next.tintColor = Helper.colors[0]
        prev.tintColor = Helper.colors[0]
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        
    }
    
    
    
    
    @IBAction func nextMonth(sender: AnyObject) {
        
        selectedIndexPath = nil
        let cal = NSCalendar.currentCalendar()
        expenseMonthDate = cal.dateByAddingUnit(.Month, value: 1, toDate: expenseMonthDate, options: [])!
        updateMonthlyExpenseView(expenseMonthDate)
    }
    
    
    @IBAction func prevMonth(sender: AnyObject) {
        selectedIndexPath = nil
        let cal = NSCalendar.currentCalendar()
        expenseMonthDate = cal.dateByAddingUnit(.Month, value: -1, toDate: expenseMonthDate, options: [])!
        updateMonthlyExpenseView(expenseMonthDate)
    }
    
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ExpenseViewController.myAction(_:)))
        cell!.addGestureRecognizer(headerTapGesture)
        
        let index = expenseData!.startIndex.advancedBy(section)
        
        header.catg.text = expenseData!.keys[index]
        
        
        
        let data = expenseData!.values[index] as! [ExpenseTable]
        var price : Float = 0.0
        for element in data{
            price += Float(element.amount ?? "0") ?? 0.0
        }
        
        
        header.price.text = price.asLocaleCurrency
        
        
        
        if  Helper.expandedAndCollapsedSectionsExpense[section]
        {
           // header.image.image = UIImage(named: "arrowDown")
            header.separator.hidden = true
        }
        else{
            //header.image.image = UIImage(named: "arrowRight")
            header.separator.hidden = false
        }
        header.headerCellSection = section
        
        return header
    }
    
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    
    
    
    func myAction (sender: UITapGestureRecognizer) {
        
        
        // Get the view
        let senderView = sender.view as! TableSectionHeader
        
        let section = senderView.headerCellSection
        
        //do it before table reload
        //change the value of section to expandable or not expandable
        Helper.expandedAndCollapsedSectionsExpense[section] = !Helper.expandedAndCollapsedSectionsExpense[section]
       //print(Helper.expandedAndCollapsedSectionsExpense[section], section)
        
        
        // Get the section
        sectionTapped  = section
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  Helper.expandedAndCollapsedSectionsExpense[section]
        {
            let index = expenseData!.values.startIndex.advancedBy(section)
            
            let array = expenseData!.values[index]
            expenseDataForSection = array as? [ExpenseTable]
           //print(array.count)
            return array.count
        }
        else
        {
            return 0
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return expenseData!.count
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        expenseMonthDate = NSDate()
        updateMonthlyExpenseView(expenseMonthDate)
        
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        let index = expenseData!.values.startIndex.advancedBy(indexPath.section)
        
        let array = expenseData!.values[index]
        expenseDataForSection = array as? [ExpenseTable]
        
        cell.subCatg.text = expenseDataForSection![indexPath.row].subCategory!.name
        //Helper.currency + expenseDataForSection![indexPath.row].amount!
        let amount = Float(expenseDataForSection![indexPath.row].amount!)
        cell.categoryAmount.text = amount?.asLocaleCurrency
        let date = String(expenseDataForSection![indexPath.row].createdAt!).componentsSeparatedByString(" ").first
        
        
        let note = expenseDataForSection![indexPath.row].note ?? ""
        
        cell.leftDown.text = date! + " " + note
        if let img = expenseDataForSection![indexPath.row].subCategory?.icon where img != ""
        {
            cell.img.image = UIImage(named: img)
            cell.img?.tintColor = Helper.colors[(indexPath.row +  indexPath.section ) % 5]
        }
        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "updateExpense") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            
            let index = expenseData!.values.startIndex.advancedBy(indexPath.section)
            
            let array = expenseData!.values[index]
            expenseDataForSection = array as? [ExpenseTable]
            
            
            
            let dvc = segue.destinationViewController as! AddExpenseViewController
            
            dvc.expenseData = expenseDataForSection![indexPath.row]
            dvc.updateExpens = true
            
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        performSegueWithIdentifier("updateExpense", sender: self)
        
    }
    
    
    func updateMonthlyExpenseView(expenseMonthDate : NSDate)
    {
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM YYYY"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(expenseMonthDate)
        
        self.titleMonth.text =  dateString
        expenseData = [:]
        
        
        
        do{
            let request = NSFetchRequest(entityName: "ExpenseTable")
            
            
            
            let (startDate , endDate) =  expenseMonthDate.getDatesOfRange(.Month)
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate, endDate)
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
            var totalAmount : Float = 0
            for element in queryResult
            {
                
                let category = element.subCategory!.category!.name
                if (expenseData![category!] == nil)
                {
                    expenseData![category!] = [element]
                    totalAmount = Float(element.amount ?? "0" ) ?? 0.0
                }
                else{
                    totalAmount += Float(element.amount ?? "0" ) ?? 0.0
                    var temp = expenseData![category!]! as! [ExpenseTable]
                    
                    temp.append(element)
                    expenseData![category!] = temp
                }
                
            }
            
            expenseTotalLabel.text = totalAmount.asLocaleCurrency
            
        }
        catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
           //print("error : ", error)
        }
        
        //append array if section increase
        if Helper.expandedAndCollapsedSectionsExpense.count < expenseData!.count
        {
            let newSections = expenseData!.count - Helper.expandedAndCollapsedSectionsExpense.count
            
            
            //to make first section expanded at launch
            if Helper.expandedAndCollapsedSectionsExpense.count == 0
            {
                Helper.expandedAndCollapsedSectionsExpense.append(true)
            }
            
            // expandedAndCollapsedSectionsExpense array can be greater then sections
            Helper.expandedAndCollapsedSectionsExpense += [Bool](count: newSections, repeatedValue: false)
            
            
            
        }
        
        
        tableView.reloadData()
        
    }
    
    
    
    
    
}
