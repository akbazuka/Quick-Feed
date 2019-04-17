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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    @IBAction func pushLifestyle(_ sender: UIButton) {
        LifestyleVC.lifestyleNum = sender.tag
        print(LifestyleVC.lifestyleNum)
        UserDefaults.standard.set("\(LifestyleVC.lifestyleNum)", forKey: "lifestyle")
        LoginVC.goTo("tabBarVC", animate: false);
    }
    
    static func loadLifestyle() -> Bool{
        LifestyleVC.lifestyleNum = Int(UserDefaults.standard.string(forKey: "lifestyle") ?? "-1") ?? -1
        return LifestyleVC.lifestyleNum >= 0
    }
    

}
