//
//  ViewController.swift
//  Dispatch
//
//  Created by MooreDev on 8/27/16.
//  Copyright © 2016 MooreDevelopments. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    //let ref = FIRDatabase.database().referenceFromURL("https://dispatcher-app-c5ff0.firebaseio.com")
    
    let deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
    
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func checkIfUserIsLoggedIn() {
       // let uid = FIRAuth.auth()?.currentUser?.uid
        //let userUid = uid
        
       if FIRAuth.auth()?.currentUser?.uid == nil{
         performSelector(#selector(logOutAction), withObject: nil, afterDelay: 0)
        //let loginController = SignInViewController()
       //presentViewController(loginController, animated: true, completion: nil)
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewControllerWithIdentifier("Sign In View Controller") as UIViewController
        //self.presentViewController(vc, animated: true, completion: nil)
            print("Did it get Here?")
        }else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("Users").child(uid!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                   // print ("\(dictionary)\[Name]")
                     let userName = dictionary["Name"] as? String
                    print(userName)
                    
                }

                }, withCancelBlock: nil)
        }
 
    }
    
    func handleLogout() {
        
        //let uid = FIRAuth.auth()?.currentUser?.uid
        //let userUid = uid
        
        if FIRAuth.auth()?.currentUser?.uid == nil{
            //presentViewController(loginController, animated: true, completion: nil)
           logOutAction(self)
        }else{
            
        
        }
    }
    
    func logOutAction(sender: AnyObject) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let userUid = uid
        
        if FIRAuth.auth()?.currentUser?.uid == nil{
            let loginController = SignInViewController()
            presentViewController(loginController, animated: true, completion: nil)
        }else{
            do{
                try FIRAuth.auth()?.signOut()
                manageOutConnection(userUid!)
            }catch let logoutError{
                print(logoutError)
            }
        }
        
        
        let loginController = SignInViewController()
        presentViewController(loginController, animated: true, completion: nil)
        
    }
    func manageOutConnection(userId: String){
        
        //create a refrence to the database
        //let myConnectionRef = FIRDatabase.database().referenceWithPath("user_profile/\(userId)/connections/\(self.deviceId!)")
        //let myConnectionRef = FIRDatabase.database().referenceWithPath("Users/\(userId)/connections/\(self.deviceId!)")
       // let ref = FIRDatabase.database().referenceFromURL("https://dispatcher-app-c5ff0.firebaseio.com")
        let myConnectionRef = FIRDatabase.database().referenceWithPath("Users/\(userId)")
        myConnectionRef.child("online").setValue("false")
        myConnectionRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
        myConnectionRef.observeEventType(.Value, withBlock: {snapshot in
            
            guard let connected = snapshot.value as? Bool where connected else {
                return
            }
            
        })
    }

}

