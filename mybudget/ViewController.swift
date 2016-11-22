//
//  ViewController.swift
//  budget
//
//  Created by Azam Rahmat on 7/21/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
        
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var currentMonth: UILabel!
    
    
    
    
    
 
    let ctgNames : [String] = ["Expenses","Income", "Budget", "Accounts", "Currency", "Transfer", "Summary", "Search"]
    
    var expensesInAccountsTotal : Float = 0.0
    var incomeInAccountsTotal : Float = 0.0
    var totalExpenses : Float = 0.0
    var totalIncome : Float = 0.0
    var totalBudget : Float = 0.0
    var ExpenceAsPercentage : CGFloat = 0.0
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    /*
     
     // Remove observer:
     notificationCenter.removeObserver(self,
     name:UIApplicationWillResignActiveNotification,
     object:nil)
     
     // Remove all observer for all notifications:
     notificationCenter.removeObserver(self)
     */
    // Callback:
    func applicationDidBecomeActiveNotification() {
        // Handle application will resign notification event.
        print("active")
        
    }
    override func viewDidDisappear(animated: Bool) {
        notificationCenter.removeObserver(self,
                                          name:UIApplicationDidBecomeActiveNotification,
                                          object:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.tintColor = Helper.colors[0]
        //tableView.backgroundColor = UIColor.greenColor()
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        // Add observer:
        
        //lockView.frame = self.view.frame
        
        //self.view.addSubview(lockView)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        formatter.locale = NSLocale.currentLocale()
        print(formatter.currencyCode, formatter.currencySymbol)
        
        
        self.title = StringFor.name["appName"]!
        
        
        // print(((self.view.frame.height  - 480 ) + 24 ) / 2)
        //bottomConstraint.constant = ((self.view.frame.height  - 480 ) + 24 ) / 2
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        Helper.addMenuButton(self)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        //currentMonth.text = dateFormatter.stringFromDate(NSDate())
        
        
        
        /*menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
         
         */
        
    }
    /*override func viewDidLayoutSubviews(){
     tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, self.view.frame.size.height /  3.5)
     // tableView.reloadData()
     }
     -override func viewDidAppear(animated: Bool) {
     tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, 50)
     }
     */
    @IBOutlet weak var collectionView: UICollectionView!
 
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        //let path = self.tableView.indexPathForSelectedRow!
        if (segue.identifier == "listView") {
            
            //let dvc = segue.destinationViewController as! ExpenseViewController
            
            
            
        }else{
            if (segue.identifier == "summary") {
                
                let dvc = segue.destinationViewController as! QuickSummaryViewController
                dvc.addMenu = false
                
                
                
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //if lockView.unlocked{
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        notificationCenter.addObserver(self,
                                       selector:#selector(ViewController.applicationDidBecomeActiveNotification),
                                       name:UIApplicationDidBecomeActiveNotification,
                                       object:nil)
        incomeInAccountsTotal  = 0
        expensesInAccountsTotal = 0
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        collectionView.reloadData()
        
        //}
        
    }
    
    
    
  
    /*
     
     func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
     {
     let cellSize:CGSize = CGSizeMake(collectionView.frame.width / 2.3 , collectionView.frame.size.height /  2.3)
     return cellSize
     }
     */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = collectionViewSize.width/2.1 //Display Three elements in a row.
        collectionViewSize.height = collectionViewSize.height/4.85
        return collectionViewSize
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        if indexPath.row == 0
        {
            self.performSegueWithIdentifier("listView", sender: nil)
        }
        else if indexPath.row == 1{
            
            self.performSegueWithIdentifier("incomeList", sender: nil)
        }
        else if indexPath.row == 2
        {
            self.performSegueWithIdentifier("budgetView", sender: nil)
        }
        else if indexPath.row == 3
        {
            self.performSegueWithIdentifier("accountList", sender: nil)
        }
        else if indexPath.row == 4
        {
            self.performSegueWithIdentifier("currency", sender: nil)
        }
        else if indexPath.row == 5{
            
            self.performSegueWithIdentifier("transfer", sender: nil)
        }
        else if indexPath.row == 6
        {
            self.performSegueWithIdentifier("summary", sender: nil)
        }
        else if indexPath.row == 7
        {
            self.performSegueWithIdentifier("search", sender: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MainCollectionViewCell
        //cell.img.image = images[indexPath.row ]
        cell.name.text = ctgNames[indexPath.row]
        
        
        
        var request = NSFetchRequest(entityName: "ExpenseTable")
        
        
        let (startDate , endDate) =  NSDate().getDatesOfRange(.Month)
        let predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate, endDate)
        
        
        
        if indexPath.row == 0
        {
            
            request = NSFetchRequest(entityName: "ExpenseTable")
            request.predicate = predicate
            do{
                
                
                totalExpenses = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
                
                for element in queryResult
                {
                    
                    
                    totalExpenses += Float(element.amount ?? "0") ?? 0.0
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            
            cell.price.text = totalExpenses.asLocaleCurrency
            let color = UIColor(red: 254/255, green: 129/255, blue: 0, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "wallet")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
            
        }
        else if indexPath.row == 1
        {
            request = NSFetchRequest(entityName: "IncomeTable")
            request.predicate = predicate
            do{
                
                
                totalIncome = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [IncomeTable]
                
                for element in queryResult
                {
                    
                    totalIncome += Float(element.amount ?? "0") ?? 0.0
                    
                    
                    
                    
                    
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = totalIncome.asLocaleCurrency
            
            let color = UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "money")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
        }else if indexPath.row == 2
        {
            request = NSFetchRequest(entityName: "SubCategoryTable")
            request.predicate = nil
            do{
                
                
                totalBudget = 0.0
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [SubCategoryTable]
                
                for element in queryResult
                {
                    
                    
                    
                    if let value =  Float(element.amount ?? "0")
                    {
                        totalBudget += value
                        
                    }
                    
                }
                if totalBudget == 0.0
                {
                    do{
                        
                        request = NSFetchRequest(entityName: "Other")
                        let queryResult = try managedObjectContext?.executeFetchRequest(request).first
                        if let result = queryResult as? Other{
                            totalBudget = Float(result.oneBudget ?? "0") ?? 0.0
                        }
                    }
                    catch let error {
                        print("error : ", error)
                    }
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = totalBudget.asLocaleCurrency
            
            
            let color = UIColor(red: 50/255, green: 195/255, blue: 0, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "folder")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
        }else if indexPath.row == 3
        {
            var total : Float = 0.0
            request = NSFetchRequest(entityName: "AccountTable")
            request.predicate = nil
            do{
                
                
                
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [AccountTable]
                
                for element in queryResult
                {
                    
                    
                    total += Float(element.amount ?? "0") ?? 0.0
                    if  let data = element.expense!.allObjects as? [ExpenseTable]
                    {
                        var expenses : Float = 0.0
                        
                        for expense in data
                        {
                            expenses += Float(expense.amount ?? "0") ?? 0.0
                        }
                        expensesInAccountsTotal += expenses
                        
                        
                    }
                    if  let data = element.income!.allObjects as? [IncomeTable]
                    {
                        var incomes : Float = 0.0
                        for income in data
                        {
                            incomes += Float(income.amount ?? "0") ?? 0.0
                        }
                        incomeInAccountsTotal += incomes
                    }
                }
            }
                
                
            catch let error {
                print("error : ", error)
            }
            cell.price.text = (total - expensesInAccountsTotal + incomeInAccountsTotal).asLocaleCurrency
            if totalBudget == 0
            {
               // available.text = (totalIncome -  totalExpenses).asLocaleCurrency
                //percentageText.text = "Expenses as % of Income"
                var pt = 0
                if totalIncome != 0 // to solve infinity problem
                {
                    pt = Int((totalExpenses / totalIncome) * 100)
                }else if totalExpenses > 0
                {
                    pt = 101 // to solve 100+ problem
                }
                //percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
                ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
            }
            else{
                
                //available.text = (totalBudget -  totalExpenses).asLocaleCurrency
                //percentageText.text = "Expenses as % of Budget"
                var pt = 0
                if totalBudget != 0
                {
                    pt = Int((totalExpenses / totalBudget) * 100)
                }else if totalExpenses > 0
                {
                    pt = 100
                }
                //percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
                ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
                
            }
            
            let color = UIColor(red: 69/255, green: 68/255, blue: 205/255, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "account")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
        }
        
        
        if indexPath.row == 7
        {
            
            
            
            cell.price.text = ""
            let color = UIColor(red: 206/255, green: 193/255, blue: 99/255, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "search")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
            
        }
        else if indexPath.row == 6
        {
            
        cell.price.text = ""
            
            let color = UIColor(red: 0/255, green: 113/255, blue: 139/255, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "ic_functions")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
        }else if indexPath.row == 5
        {
                        cell.price.text = ""
            
            
            let color = UIColor(red: 200/255, green: 0/255, blue: 0/255, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "ia_transfer")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
        }else if indexPath.row == 4
        {
            cell.price.text = ""
            let color = UIColor(red: 136/255, green:78/255, blue: 160/255, alpha: 1)
            //cell.price.textColor = color
            cell.img.image = UIImage(named: "account")
            cell.img.tintColor = UIColor.whiteColor()
            cell.contentView.backgroundColor = color
            
        }

        
        //cell.img?.tintColor = Helper.colors[indexPath.row % 5]
        return cell
    }
    
    
}

