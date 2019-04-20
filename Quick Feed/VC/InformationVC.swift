//
//  InformationVC.swift
//  Quick Feed
//
//  Created by AK on 4/18/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit

class InformationVC: UIViewController{
    
    //Back Button
    @IBOutlet weak var backButtonInfo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButtonInfo.addTarget(self, action: #selector(pushToNextVC), for: .touchUpInside)
        self.view.addSubview(backButtonInfo)
    }
    
    @objc func pushToNextVC() {
        
        let newVC = UIViewController()
        self.navigationController?.pushViewController(newVC, animated:
            true)
    }
    
    @IBAction func backButtonPressedInfo(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        //self.performSegue:@"showTabBar" sender:senderButton as [Any]
        }
        
}
