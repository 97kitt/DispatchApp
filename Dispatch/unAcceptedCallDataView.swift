//
//  unAcceptedCallDataView.swift
//  Dispatch_App
//
//  Created by MooreDev on 9/5/16.
//  Copyright © 2016 MooreDevelopments. All rights reserved.
//

import UIKit
import Firebase

class unAcceptedCallDataView: UIViewController {
    
    var users = [User]()
     //var productsValue = [[String:String]]()

    @IBOutlet weak var nameLable: UILabel!
    var LableText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLable.text = LableText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUser() {
        
        FIRDatabase.database().reference().child("Calls").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                
                
                user.setValuesForKeysWithDictionary(dictionary)
                self.users.append(user)
            
                
               //dispatch_async(dispatch_get_main_queue(),{self.tableView.reloadData()})
                
            }
            
            }, withCancelBlock: nil)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
