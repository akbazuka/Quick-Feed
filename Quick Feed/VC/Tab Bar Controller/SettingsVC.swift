//
//  SettingsVC.swift
//  Quick Feed
//
//  Created by AK on 3/31/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit
import MessageUI

class SettingsVC: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    var settingsText = ["Change Lifestyle Choice"/*, "Signup Page"*/,"Contact Us", "Rate Us", "Information", "Logout"]
    var settingsImages = [UIImage(named: "restaurantPic")/*, UIImage(named: "identityPic")*/, UIImage(named: "helpPic"), UIImage(named: "outline_grade_black_48pt_3x"), UIImage(named: "infoPic"), UIImage(named: "exit"), ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func sendEmail(subject: String, body: String, to: String){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody(body, isHTML: false)
            mail.setToRecipients([to])
            mail.setSubject(subject)
            present(mail, animated: true, completion: nil)
        } else {
//            HomeVC.alert(message: "An error occured while trying to open mail. Please send report to hawaiicleanup@gmail.com",
//                         title: "Email Error",actionType: .default)
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            break
            //HomeVC.alert(message: "An error occured while trying to open mail. Error: \(error?.localizedDescription ?? "Error")",
                //title: "Email Error", actionType: .default)
            //print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    //Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsText.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    //Properties of cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont(name: "LaoSangamMN", size: 26)
        
        //Properties; Title assigned to rows
        cell.textLabel?.text = settingsText[indexPath.row]
        
        //Assign images
        cell.imageView?.image = settingsImages[indexPath.row]
        
        return cell
    }
    
    //Selecting a specific row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Unselects table view cell after clicking
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch settingsText[indexPath.row] {
        case "Change Lifestyle Choice":
            LifestyleVC.isFromSettings = true
            goTo("LifestyleVC", animate: true)
            
            break
        
            /*
        case "Account Login":
            goTo("SignUpVC", animate: true)
            
            break
            */
        case "Information":
            goTo("InformationVC", animate: true)
            break
        
       case "Logout":
            UserDefaults.standard.set(nil, forKey: "uID")
            LifestyleVC.lifestyleNum = -1
            LifestyleVC.saveLifeStyle()
            goTo("SignUpVC", animate: true)
            break
        case "Contact Us":
            
            sendEmail(subject: "Question from User", body: "", to: "anikedz@gmail.com")
            
            break
            
        case "Rate Us":
            alert(title: "Inactive Button", message: "This button is not active yet")
            
            break
            
        default:
            break
        }
    }
    
    //Alert Method
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Presnt to Screen
        present(alert,animated: true,completion: nil)
    }
    
    //goTo Method
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
