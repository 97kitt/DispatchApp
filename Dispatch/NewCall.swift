//
//  NewCall.swift
//  Dispatch
//
//  Created by MooreDev on 8/27/16.
//  Copyright © 2016 MooreDevelopments. All rights reserved.
//

import UIKit
import Firebase

class NewCall: UIViewController {
    
    
    @IBOutlet weak var newCallScrollView: UIScrollView!
   

    @IBOutlet weak var callNavBar: UINavigationBar!

    @IBOutlet weak var nameTextField: UITextField!


    @IBOutlet weak var addressTextField: UITextField!

    @IBOutlet weak var zoneTextField: UITextField!

    
    @IBOutlet weak var phoneOneTextField: UITextField!
    
    @IBOutlet weak var phoneTwoTextField: UITextField!
    
    
    
    @IBOutlet weak var vehicleTextField: UITextField!
    
    @IBOutlet weak var jobTypeTextField: UITextField!
    
    @IBOutlet weak var poNumberTextField: UITextField!
    
    @IBOutlet weak var mcTextField: UITextField!
    
    
    @IBOutlet weak var notesTextField: UITextField!
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        newCallScrollView.contentSize.height = 1000
        
         //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .Plain, target: callNavBar, action: #selector(sendAction))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendToDB(sender: AnyObject) {
        guard let Name = nameTextField.text, address = addressTextField.text, zoneArea = zoneTextField.text, phone1 = phoneOneTextField.text, phone2 = phoneTwoTextField.text, vehicle = vehicleTextField.text, jobtype = jobTypeTextField.text, ponum = poNumberTextField.text, mc = mcTextField.text, notes = notesTextField.text else{
            print("This is not Right")
            return

            
        }
        let alertController = UIAlertController(title: "Send Call Out", message: "Are You Sure You Want To Send This Out?", preferredStyle: UIAlertControllerStyle.Alert)
        let DestructiveAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive) { (result : UIAlertAction) -> Void in
           // print("Destructive")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
      
            let calls = FIRDatabase.database().referenceWithPath("Calls")
            let myConnectionRef = calls.childByAutoId()

            myConnectionRef.child("Name").setValue(Name)
            myConnectionRef.child("Adress").setValue(address)
            myConnectionRef.child("Zone_Area").setValue(zoneArea)
            myConnectionRef.child("Phone1").setValue(phone1)
            myConnectionRef.child("Phone2").setValue(phone2)
            myConnectionRef.child("Vehicle").setValue(vehicle)
            myConnectionRef.child("Job_Type").setValue(jobtype)
            myConnectionRef.child("PO_Number").setValue(ponum)
            myConnectionRef.child("MC").setValue(mc)
            myConnectionRef.child("Notes").setValue(notes)
            myConnectionRef.child("Job_Status").setValue("Unaccepted")
            //myConnectionRef.child("Time_Logged").setValue(NSDate())
            myConnectionRef.child("Time_Logged").setValue(NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle:NSDateFormatterStyle.NoStyle , timeStyle: NSDateFormatterStyle.ShortStyle))
            myConnectionRef.observeEventType(.Value, withBlock: {snapshot in
            
                guard let connected = snapshot.value as? Bool where connected else {
                    return
                }
                
            })
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("dashBoardView") as UIViewController
            // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
            
            self.presentViewController(viewController, animated: false, completion: nil)
            //self.presentViewController(nextViewController, animated:true, completion:nil)
            //self.backAction
            //self.presentViewController(navViewController, animated: true, completion: nil)
            print("OK")
        }
        alertController.addAction(DestructiveAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    
    
    }
   
    @IBOutlet weak var backAction: UIBarButtonItem!
    
     func sendAction(userId: String) {
        
        
        
        //let calls = Firebase(url: "\("https://dispatcher-app-c5ff0.firebaseio.com")/Calls")
        //let ref = FIRDatabase.database().referenceFromURL("https://dispatcher-app-c5ff0.firebaseio.com")
        guard let Name = nameTextField.text, address = addressTextField.text, zoneArea = zoneTextField.text else{
            print("This is not Right")
            return
        }
        //create a refrence to the database
        let myConnectionRef = FIRDatabase.database().referenceWithPath("user_profile/\(userId)/connections/)")
        //let Name = nameTextField.text
        //let calls = FIRDatabase.database().referenceWithPath("Calls")
       // let myConnectionRef = calls.childByAutoId()
        //let myConnectionRef = FIRDatabase.database().referenceWithPath("Users/\(userId)")
        myConnectionRef.child("Name").setValue(Name)
        myConnectionRef.child("Adress").setValue(address)
        myConnectionRef.child("Zone").setValue(zoneArea)
        //myConnectionRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        myConnectionRef.observeEventType(.Value, withBlock: {snapshot in
            
            guard let connected = snapshot.value as? Bool where connected else {
                return
            }
            
        })
        
        
    }
    /*func manageConnection(userId: String){
        
        //create a refrence to the database
        //let myConnectionRef = FIRDatabase.database().referenceWithPath("user_profile/\(userId)/connections/\(self.deviceId!)")
       //let Name = nameTextField.text
        
        let myConnectionRef = FIRDatabase.database().referenceWithPath("Calls")
        //let myConnectionRef = FIRDatabase.database().referenceWithPath("Users/\(userId)")
        myConnectionRef.child("Name").setValue(Name)
        //myConnectionRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        myConnectionRef.observeEventType(.Value, withBlock: {snapshot in
            
            guard let connected = snapshot.value as? Bool where connected else {
                return
            }
            
        })

    }
 */
    
    
    }




