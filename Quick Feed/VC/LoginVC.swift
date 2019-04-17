//
//  LoginVC.swift
//  Quick Feed
//
//  Created by AK on 4/11/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit
import Firebase

class LoginVC : UIViewController{
    
    //Email Login Text Field
    @IBOutlet weak var emailLoginText: UITextField!
    
    //Password Login Text Field
    @IBOutlet weak var passwordLoginText: UITextField!
    
    static var UID : String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        hideKeyboard()
        
    }
    
    @IBAction func forgotButtonPressed(_ sender: UIButton) {
        //reset password
        resetPassword()
    }
    //Login Button
    @IBAction func loginButton(_ sender: UIButton) {
        
        //if email and password fields are not empty
        if let email = emailLoginText.text, let password = passwordLoginText.text, !password.isEmpty, !email.isEmpty {
            print("Error")
            
            //Calls authenticateNewUser method
            authenticateUser(email: email, password: password)
        }
        
        else{
            print("Nope")
            //Error message
            alert(title:"Error", message: "Please fill in Login information")
        }
        
    }
    
    //Saves UID
    static func saveUID(){
        UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "uid")
    }
    
    //Loads UID
    static func loadUID()-> Bool{
        LoginVC.UID = UserDefaults.standard.string(forKey:"uid")
        return LoginVC.UID != nil
    }
    
    //Login User
    func authenticateUser(email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password){(user,error) in
            if user != nil {
                print("User is authenticated (user has an account)")
                print("Email:\(email)")
                LoginVC.saveUID()
                
                //Go to Main Feed
                LoginVC.goTo("tabBarVC", animate: true)
                
            } else {
                
                print("ERROR")
                
                //Call alert
                self.alert(title:"Error", message: "\(error?.localizedDescription ?? "Error registering account")")
            }
        }
    }
    
    func hideKeyboard() {
    
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(LoginVC.dismissKeyboard))
    
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        //Set placeholders
    }
    
    //Text Alert
    func alert(title:String, message: String){
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Present to screen
        present(alert, animated: true, completion: nil)
    }
    
    //Help Direct Initial VC to Navigation Controller
    static func goTo(_ view: String, animate: Bool) {
        
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
    
    //Forget Password in Login Page
    func resetPassword() {
        if let email = emailLoginText.text, !email.isEmpty{
            Auth.auth().sendPasswordReset(withEmail: email) {(error) in
                if let error = error {
                    //Error occured
                    self.alert(title: "Error", message: "\(error.localizedDescription)")
                } else {
                    self.alert(title: "Email Sent", message: "Email sent to reset password.")
                }
            }
        } else {
            self.alert(title: "Missing Email", message: "Please enter email in email in email text field first")
        }
    }
}
