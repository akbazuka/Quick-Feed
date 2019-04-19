//
//  LifestyleVCViewController.swift
//  Quick Feed
//
//  Created by AK on 3/13/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit


class LifestyleVC: UIViewController {
    static var lifestyleNum = -1
    
    static var isFromSettings = true

    @IBOutlet weak var backButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if LifestyleVC.isFromSettings{
            backButton.isEnabled = true
            self.goTo("tabBarVC", animate: true)
            
        } else{
            backButton.isEnabled = false
            self.goTo("SignUpVC", animate: true)
        }
    }
    
    @IBAction func pushLifestyle(_ sender: UIButton) {
        LifestyleVC.lifestyleNum = sender.tag
        UserDefaults.standard.set("\(LifestyleVC.lifestyleNum)", forKey: "lifestyle")
        print("Sender tag \(sender.tag)")
        print("Lifesytle \(UserDefaults.standard.string(forKey: "lifestyle"))")
        if LifestyleVC.isFromSettings{
            
            updateLifesetyle(lifestyleID: "\(LifestyleVC.lifestyleNum)", uID: UserDefaults.standard.string(forKey: "uID") ?? "-1")
             LoginVC.goTo("tabBarVC", animate: false)
          
            
        } else{
            //Push Lifestyle to Database
            pushUser(uID: UserDefaults.standard.string(forKey: "uID") ?? "-1", lifestyleID: "\(LifestyleVC.lifestyleNum)")
            LoginVC.goTo("tabBarVC", animate: false)
        }
       
    }
    
    static func loadLifestyle() -> Bool{
        LifestyleVC.lifestyleNum = Int(UserDefaults.standard.string(forKey: "lifestyle") ?? "-1") ?? -1
        return LifestyleVC.lifestyleNum >= 0
    }
    
    //Push user name to database
    func pushUser(uID: String, lifestyleID: String){
        
        //Create url string
        let urlString = SignUpVC.dataURL + "insertUser&uID=\(uID)&lifestyleID=\(lifestyleID)"
        
        //Encode url
        let result = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Error"
        
        //Create url
        guard let url = URL(string: result) else { return }
        
        //Send url
        URLSession.shared.dataTask(with: url).resume()
        
        print("URL Sent: \(url)")
    }
    
    //Update lifestyle in database
    func updateLifesetyle(lifestyleID: String,uID: String){
        
        //Create url string
        let urlString = SignUpVC.dataURL + "updateLifestyle&lifestyleID=\(lifestyleID)&uID=\(uID)"
        
        //Encode url
        let result = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Error"
        
        //Create url
        guard let url = URL(string: result) else { return }
        
        //Send url
        URLSession.shared.dataTask(with: url).resume()
        
        print("URL Sent: \(url)")
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
