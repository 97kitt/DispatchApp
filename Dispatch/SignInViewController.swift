//
//  SignInViewController.swift
//  Dispatch
//
//  Created by MooreDev on 8/27/16.
//  Copyright © 2016 MooreDevelopments. All rights reserved.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {
  
        
        let deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        
        let inputsContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.whiteColor()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.cornerRadius = 5
            view.layer.masksToBounds = true
            return view
        }()
        
        lazy var loginRegisterButton: UIButton = {
            let button = UIButton(type: .System)
            button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
            button.setTitle("Register", forState: .Normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
            
            button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
            
            return button
        }()
        
        func handleLoginRegister(){
            if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
                handleLogin()
            }else{
                handleRegister()
            }
            
            
        }
        
        func handleLogin(){
            guard let email = emailTextField.text, password = passwordTextField.text else{
                print("This is not Right")
                return
            }
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion:{(user, error) in
                if error != nil {
                    print(error)
                    return
                }
                let uid = FIRAuth.auth()?.currentUser?.uid
                let userUid = uid
                self.manageConnection(userUid!)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })
        }
        
        func handleRegister(){
            
            guard let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text else{
                print("This is not Right")
                return
            }
            FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
                if error != nil{
                    print(error)
                    return
                }
                
                guard let uid = user?.uid else{
                    return
                    
                }
                
                //success
                let ref = FIRDatabase.database().referenceFromURL("https://dispatcher-app-c5ff0.firebaseio.com")
                let usersReference = ref.child("Users").child(uid)
                let values = ["Name": name, "eMail": email]
                usersReference.updateChildValues(values, withCompletionBlock:  {(err, ref) in
                    if err != nil{
                        
                        print(err)
                        return
                    }
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    print("Saved User Successfully into Firebas DB!")
                })
            })
        }
        func manageConnection(userId: String){
            
            //create a refrence to the database
            //let myConnectionRef = FIRDatabase.database().referenceWithPath("user_profile/\(userId)/connections/\(self.deviceId!)")
            //let myConnectionRef = FIRDatabase.database().referenceWithPath("Users/\(userId)/connections/\(self.deviceId!)")
            let myConnectionRef = FIRDatabase.database().referenceWithPath("Users/\(userId)")
            myConnectionRef.child("online").setValue("true")
            myConnectionRef.child("last_online").setValue(NSDate().timeIntervalSince1970)
            myConnectionRef.observeEventType(.Value, withBlock: {snapshot in
                
                guard let connected = snapshot.value as? Bool where connected else {
                    return
                }
                
            })
        }
        
        let nameTextField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Name"
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()
        
        let nameSeparatorView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let emailTextField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Email"
            tf.translatesAutoresizingMaskIntoConstraints = false
            return tf
        }()
        
        let emailSeparatorView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let passwordTextField: UITextField = {
            let tf = UITextField()
            tf.placeholder = "Password"
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.secureTextEntry = true
            return tf
        }()
        
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "PD_Logo.png")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .ScaleAspectFill
            return imageView
        }()
        
        lazy var loginRegisterSegmentedControl:UISegmentedControl = {
            
            let sc = UISegmentedControl(items: ["Login","Register"])
            sc.translatesAutoresizingMaskIntoConstraints = false
            sc.tintColor = UIColor.whiteColor()
            sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
            return sc
        }()
        
        func handleLoginRegisterChange() {
            let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
            loginRegisterButton.setTitle(title, forState: .Normal)
            
            // Height of inPutContainerView
            inputsContainerViewHightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
            
            // Remaove Name Text Field
            nameTextFieldHeightAnchor?.active = false
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier:loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
            nameTextFieldHeightAnchor?.active = true
            
            emailTextFieldHeightAnchor?.active = false
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
            emailTextFieldHeightAnchor?.active = true
            
            passwordTextFieldHeightAnchor?.active = false
            passwordTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
            passwordTextFieldHeightAnchor?.active = true
            
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = UIColor(r: 190, g: 190, b: 190)
            
            view.addSubview(inputsContainerView)
            view.addSubview(loginRegisterButton)
            view.addSubview(profileImageView)
            view.addSubview(loginRegisterSegmentedControl)
            
            setupInputsContainerView()
            setupLoginRegisterButton()
            setupProfileImageView()
            setupLoginRegisterSegmentedControl()
        }
        
        func setupLoginRegisterSegmentedControl(){
            //need x, y, width, height constraints
            loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active=true
            loginRegisterSegmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
            loginRegisterSegmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor, multiplier: 1).active = true
            loginRegisterSegmentedControl.heightAnchor.constraintEqualToConstant(36).active = true
            
            
        }
        
        func setupProfileImageView() {
            //need x, y, width, height constraints
            profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            profileImageView.bottomAnchor.constraintEqualToAnchor(loginRegisterSegmentedControl.topAnchor, constant: -5).active = true
            profileImageView.widthAnchor.constraintEqualToConstant(250).active = true
            profileImageView.heightAnchor.constraintEqualToConstant(250).active = true
        }
        
        var inputsContainerViewHightAnchor: NSLayoutConstraint?
        var nameTextFieldHeightAnchor:NSLayoutConstraint?
        var emailTextFieldHeightAnchor:NSLayoutConstraint?
        var passwordTextFieldHeightAnchor:NSLayoutConstraint?
        
        func setupInputsContainerView() {
            
            
            
            //need x, y, width, height constraints
            inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
            inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
            
            inputsContainerViewHightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
            inputsContainerViewHightAnchor?.active = true
            
            inputsContainerView.addSubview(nameTextField)
            inputsContainerView.addSubview(nameSeparatorView)
            inputsContainerView.addSubview(emailTextField)
            inputsContainerView.addSubview(emailSeparatorView)
            inputsContainerView.addSubview(passwordTextField)
            
            //need x, y, width, height constraints
            nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
            nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
            
            nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
            
            nameTextFieldHeightAnchor?.active = true
            
            //need x, y, width, height constraints
            nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
            nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
            nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
            
            //need x, y, width, height constraints
            emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
            emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
            
            emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            
            emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
            emailTextFieldHeightAnchor?.active = true
            
            //need x, y, width, height constraints
            emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
            emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
            emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
            
            //need x, y, width, height constraints
            passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
            passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
            
            passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
            passwordTextFieldHeightAnchor?.active = true
        }
        
        func setupLoginRegisterButton() {
            // need x, y, width, height constraints
            loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
            loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
            loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
            loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
        }
        
        override func preferredStatusBarStyle() -> UIStatusBarStyle {
            return .LightContent
        }
    }
    
    extension UIColor {
        
        convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
            self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
        }
        
}








