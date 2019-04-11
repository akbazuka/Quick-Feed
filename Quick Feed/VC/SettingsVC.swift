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
    var settingsText = ["Change Lifestyle Choice", "Contact Us", "Rate Us"]
    var settingsImages = [UIImage(named: "outline_home_black_48pt_3x"), UIImage(named: "outline_perm_identity_black_48pt_3x"), UIImage(named: "outline_search_black_48pt_3x")]
    
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
    
    //Properties of cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        //Properties; Title assigned to rows
        cell.textLabel?.text = settingsText[indexPath.row]
        
        //Assign images
        cell.imageView?.image = settingsImages[indexPath.row]
        
        return cell
    }
    
    //Selecting a specific row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch settingsText[indexPath.row] {
        case "Change Lifestyle Choice":
            
            //Insert code
            
            break
            
        case "Contact Us":
            
            sendEmail(subject: "Question from User", body: "", to: "anikedz@gmail.com")
            
            break
            
        case "Rate Us":
            
            //INsert Code
            
            break
            
        default:
            break
        }
    }
    

}
