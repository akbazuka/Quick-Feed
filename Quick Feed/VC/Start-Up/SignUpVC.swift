//
//  ViewController.swift
//  Quick Feed
//
//  Created by AK on 2/12/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
    //Email Text Field
    @IBOutlet weak var emailText: UITextField!
    //Password Text Field
    @IBOutlet weak var passwordText: UITextField!
    
    static var guestUser = 0
    
    static var dataURL = "https://quickfeed.net/quickFeedService1.php?type="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        if(LoginVC.loadUID()){
            if(LifestyleVC.loadLifestyle()){
                //Have user login info and lifestyle
                goTo("tabBarVC", animate: true)
            } else {
                //Have user login info and not lifestyle
                goTo("LifestyleVC", animate: false)
            }
            print(LifestyleVC.loadLifestyle(), "Yo")
        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func guestUserButtonIsPressed(_ sender: UIButton) {
        
        SignUpVC.guestUser = 1;
        LifestyleVC.isFromSettings = false
    }
    
    //Sign-up Button
    @IBAction func signUpButton(_ sender: UIButton) {
        
        LifestyleVC.isFromSettings = false
        //if email and password fields are not empty
        if let email = emailText.text, let password = passwordText.text,
            !password.isEmpty, !email.isEmpty {
            
            //Calls authenticateNewUser method
            authenticateNewUser(email: email, password: password)
        }
            
        else {
            
            //Error Message
            alert(title: "Error", message: "Text fields cannot be empty")
        }
    }
    
    //Text Alert
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Presnt to Screen
        present(alert,animated: true,completion: nil)
    }
    
    //Authenticate User Sign-ups
    func authenticateNewUser(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            
            (authResult, error)
            
            in
            ///...
            let user = authResult?.user
            UserDefaults.standard.set(user?.uid, forKey: "uID")
            
            //Checking User Value
            if user != nil{
                self.goTo("LifestyleVC", animate: true)
                LifestyleVC.isFromSettings = false
                //print("User is NOT NIL")
            }
                
            else {
                //Error goes here if trouble logging in
                self.alert( title: "Error", message: "\(error?.localizedDescription ?? "Error registering account")")
            }
        }
    }
    
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(SignUpVC.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
        //Set Placeholders
    }
    
    //Help Direct Initial VC to Navigation Controller
    func goTo(_ view: String, animate: Bool){
        OperationQueue.main.addOperation {
            func topMostController() -> UIViewController {
                var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                while (topController.presentedViewController != nil) {
                    topController = topController.presentedViewController!
                }
                return topController
            }
            if let second = topMostController().storyboard?.instantiateViewController(withIdentifier: view) {
                topMostController().present(second, animated: animate, completion: nil)
                // topMostController().navigationController?.pushViewController(second, animated: animate)
                
            }
        }
    }
}

