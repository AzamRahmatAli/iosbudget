//
//  AccountsViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class AccountsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var transferView: UIView!
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    
  
    
    var accountData : [AccountTypeTable] = []
    var calculatedAmount = [[Float]]()
    
    var sectionTapped = -1{
        didSet{
            
            tableView.reloadData()
        }
        
    }
    
    var dataForSection = [AccountTable]()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var accountTotalLabel: UILabel!
    @IBAction func addExpense(sender: AnyObject) {
        self.performSegueWithIdentifier("addAccount", sender: nil)
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.registerNib(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
        if Helper.pickAccount
        {
        transferView.hidden = true
        }
    }
    
    
    

    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableSectionHeader")
        let header = cell as! TableSectionHeader
        
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ExpenseViewController.myAction(_:)))
        cell!.addGestureRecognizer(headerTapGesture)
        
        let index = section
        
        header.catg.text = accountData[index].name
        
        
        
        let data = calculatedAmount[section]
        var price : Float = 0.0
        for amount in data{
            
            price += amount
            
        }
        header.price.text = price.asLocaleCurrency
        if price < 0
        {
            header.price.textColor = UIColor.redColor()
        }
        else{
            header.price.textColor = UIColor.blackColor()
        }
        
        
        
        if  Helper.expandedAndCollapsedSectionsAccount[section]
        {
            header.image.image = UIImage(named: "arrowDown")
            header.separator.hidden = true
        }
        else{
            header.image.image = UIImage(named: "arrowRight")
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
        Helper.expandedAndCollapsedSectionsAccount[section] = !Helper.expandedAndCollapsedSectionsAccount[section]
        print(Helper.expandedAndCollapsedSectionsAccount[section], section)
        
        // Get the section
        sectionTapped  = section
       
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  Helper.expandedAndCollapsedSectionsAccount[section]
        {
         
            
             dataForSection = accountData[section].account!.allObjects as! [AccountTable]
            
            
            return dataForSection.count
        
        }
        else
        {
            return 0
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        print("accountData.count= ", accountData.count)
        return accountData.count
        
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        updateMonthlyExpenseView()
        
        
        
    }
    
    
    func calculateCurrentAmountAfterExpenses(amount : Float, row : Int) -> Float?
    {
        var total = amount
        if let incomes =  dataForSection[row].income?.allObjects as? [IncomeTable]
        {
            for element in incomes
            {
                total += Float(element.amount ?? "0") ?? 0.0
            }
        }
        if let expenses =  dataForSection[row].expense?.allObjects as? [ExpenseTable]
        {
            for element in expenses
            {
                total -= Float(element.amount ?? "0") ?? 0.0
            }
        }
        if let transfers =  dataForSection[row].transferTo?.allObjects as? [TransferTable]
        {
            for element in transfers
            {
                if element.transferAt?.compare(NSDate()) == .OrderedAscending
                {
                total -= Float(element.amount ?? "0") ?? 0.0
                }
            }
        }
        if let transfers =  dataForSection[row].transferFrom?.allObjects as? [TransferTable]
        {
            for element in transfers
            {
                if element.transferAt?.compare(NSDate()) == .OrderedAscending
                {
                total += Float(element.amount ?? "0") ?? 0.0
                }
            }
        }
        return total
        
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        
         dataForSection = accountData[indexPath.section].account!.allObjects as! [AccountTable]
        
        cell.subCatg.text = dataForSection[indexPath.row].name
        cell.leftDown.text = "Reconciled: " + Float(dataForSection[indexPath.row].amount ?? "0")!.asLocaleCurrency
        
        let total = calculatedAmount[indexPath.section][indexPath.row]
        cell.rightUp.text = total.asLocaleCurrency
        if total < 0
        {
            cell.rightUp.textColor = UIColor.redColor()
        }
        else{
            cell.rightUp.textColor = UIColor.blackColor()
        }
        
        if let image = dataForSection[indexPath.row].icon
        {
        cell.img.image = UIImage(named: image)
        cell.img?.tintColor = Helper.colors[(indexPath.row +  indexPath.section ) % 5]
        }
        
        return cell
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "updateAccount"
        {
        let indexPath = self.tableView.indexPathForSelectedRow!
        dataForSection = accountData[indexPath.section].account!.allObjects as! [AccountTable]
        let dvc = segue.destinationViewController as! AddAccountViewController
        
        dvc.accountData = dataForSection[indexPath.row]
        dvc.updateAccount = true
        }
        
    }
    
    func updateMonthlyExpenseView( )
    {
        var i = 0, j = 0
        
        do{
            let request = NSFetchRequest(entityName: "AccountTypeTable")
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTypeTable]
            
            
            accountData = queryResult
            calculatedAmount = [[Float]](count: accountData.count , repeatedValue: [])
            var totalAmount : Float = 0
            for element in accountData
            {
                if let accounts = element.account?.allObjects as? [AccountTable]
                    {
                           dataForSection = accounts //using in calculateCurrentAmountAfterExpenses
                        for account in accounts{
                         
                            if let amount = calculateCurrentAmountAfterExpenses(Float(account.amount ?? "0") ?? 0.0, row:  j)
                            {
                            calculatedAmount[i].append(amount)
                                totalAmount += amount
                        }
                            j += 1
                        }
                        j = 0
                }
                i += 1
            }
            accountTotalLabel.text = totalAmount.asLocaleCurrency
         
            
            
            //append array if section increase
            if Helper.expandedAndCollapsedSectionsAccount.count < accountData.count
            {
                let newSections = accountData.count - Helper.expandedAndCollapsedSectionsAccount.count
                
                
                //to make first section expanded at launch
                if Helper.expandedAndCollapsedSectionsAccount.count == 0
                {
                    Helper.expandedAndCollapsedSectionsAccount.append(true)
                }
                
                // expandedAndCollapsedSectionsAccount array can be greater then sections
                Helper.expandedAndCollapsedSectionsAccount += [Bool](count: newSections, repeatedValue: false)
                
                
                
            }
            
            
           
        }
            
            
        catch let error {
            print("error : ", error)
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
        
        dataForSection = accountData[indexPath.section].account!.allObjects as! [AccountTable]
        if Helper.pickAccount        {
            //  let index = expenseData.startIndex.advancedBy(indexPath.row)
            Helper.pickedAccountData = dataForSection[indexPath.row]
            
            
            Helper.accountPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            self.performSegueWithIdentifier("updateAccount", sender: nil)
            
        }
        
        
    }
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            if Helper.pickAccount        {
                Helper.pickAccount = false
            }
        }
    }
    
    
}
