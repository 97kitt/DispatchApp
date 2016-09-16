//
//  ActiveCallsTableViewController.swift
//  Dispatch
//
//  Created by MooreDev on 8/30/16.
//  Copyright © 2016 MooreDevelopments. All rights reserved.
//

import UIKit
import Firebase

extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date: NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date: NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}

class ActiveCallsTableViewController: UITableViewController {
    
 
    
    let cellId = "cellId"
    var users = [User]()
    var unAcceptedUsers = [User]()
    var enRoute = [User]()
    var onSite = [User]()
    //let items = [[unAcceptedUsers],[enRoute]]()
    var isFiltered = Bool()
    
   let section = ["Unaccepted", "Enroute", "Onsite"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        
        
        fetchUser()
    
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.section[section]
        
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 3
       
    }
    
    /// Returns the amount of minutes from another date
 
    func fetchUser() {
        
        FIRDatabase.database().reference().child("Calls").observeEventType(.ChildAdded, withBlock: { (snapshot) in
           
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()

               
                user.setValuesForKeysWithDictionary(dictionary)
                self.users.append(user)
                
               
            
                if user.Job_Status == "Unaccepted" {
                    self.isFiltered = true
                    self.unAcceptedUsers.append(user)
                   // print("\(user.Name) True")
                }else if user.Job_Status == "Enroute"{
                    self.isFiltered = false
                   self.enRoute.append(user)
                   // print("\(user.Name) False")
                }else{
                        self.onSite.append(user)
                    }

                dispatch_async(dispatch_get_main_queue(),{self.tableView.reloadData()})

            }

            }, withCancelBlock: nil)
       
    }
    
    
    func handleCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //let items = statusUser(status.text)
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //var rowCount: Int
        if section == 0 {
            //rowCount = unAcceptedUsers.count
            return unAcceptedUsers.count
        }
        else if section == 1{
            return enRoute.count
            //rowCount = enRoute.count
            
        }else {
            return onSite.count
        }
       
       //return rowCount
    }
    
    func userForIndexPath(indexPath: NSIndexPath) -> User {
        if indexPath.section == 0 {
            // print(unAcceptedUsers)
            return unAcceptedUsers[indexPath.row]
           
        }
            print(enRoute)
            return unAcceptedUsers[indexPath.row]
    }
    
   /* func compareDate(date1:NSDate, toDate date2: NSDate, toUnitGranularity unit:NSCalendarUnit) ->NSComparisonResult{
        let user = User()
        
        
        let now = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        let timeLogged = dateFormatter.dateFromString("\(user.Time_Logged)")
        
        let order = NSCalendar.currentCalendar().compareDate(now, toDate: timeLogged!, toUnitGranularity:.Minute)
        
        switch order {
        case .OrderedDescending:
            print("DESCENDING")
        case .OrderedAscending:
            print("ASCENDING")
        case .OrderedSame:
            print("SAME")
        }
        return order
    }
 */
 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //print("Call Cell")
        //let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
        let user:User
        //let user = userForIndexPath(indexPath)
        
        if indexPath.section == 0 {
            user = unAcceptedUsers[indexPath.row]
        }else if indexPath.section == 1{
            user = enRoute[indexPath.row]
        }else{
            user = onSite[indexPath.row]
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        let date3 = dateFormatter.dateFromString(user.Time_Logged!)
        print(date3)
        
       let elapesedTime = NSDate().timeIntervalSinceDate(date3!)
        //let minutesPassed = (elapesedTime / 3600)
        
        //let dateMinutes = NSDate().timeIntervalSinceReferenceDate (date3)
        
       // let calcendar = NSCalendar.currentCalendar()
        //let dateComponents = calcendar.components(NSCalendarUnit.Minute, fromDate: date3!, toDate: NSDate(), options: nil)
        //let minutesPassed = dateComponents
        print (elapesedTime)
        
        let duration = Int(elapesedTime)
        let minutesLogged = String(duration)
       print(duration)
        

        //let user = users[indexPath.row]
        cell.textLabel?.text = user.Name
        cell.detailTextLabel?.text = minutesLogged
        //print(user.Adress)
        
       
       /*
        if user.Time_Logged < date2  {
           cell.detailTextLabel?.textColor = UIColor.greenColor()
        }else if user.Time_Logged < date6{
            cell.detailTextLabel?.textColor = UIColor.orangeColor()
        }else if user.Time_Logged > date6{
            cell.detailTextLabel?.textColor = UIColor.redColor()
        }
*/
        return cell
        
    }
    //var valueToPass:String!
    var valueToPass:String!
    //var productsValue = [unAcceptedCallDataVie]]
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let callInfoView:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Callinfo") as UIViewController
        let unAcceptedView:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("unAcceptedCall") as UIViewController
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        let currentCell2 = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!;
        
        if indexPath.section == 0 {
            valueToPass = currentCell.textLabel!.text
            //valueToPass = currentCell2
            performSegueWithIdentifier("passData", sender: self)
            self.presentViewController(unAcceptedView, animated: true, completion: nil)
            
            //print(valueToPass)
        }else if indexPath.section == 1{
            self.presentViewController(callInfoView, animated: true, completion: nil)
            print("Enroute")
        }else {
            self.presentViewController(callInfoView, animated: true, completion: nil)
            print("Onsite")
        }
       // print(user.Adress)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "passData") {
            //let user:User
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destinationViewController as! unAcceptedCallDataView
            
            // your new view controller should have property that will store passed value
            //var passedValue = viewController.nameLable.text
            //print(user.Adress)
            viewController.LableText = valueToPass
            print("Name of Vaule is \(valueToPass)")
            
        }
    
}
    
}
    


class UserCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
       
    }
}
