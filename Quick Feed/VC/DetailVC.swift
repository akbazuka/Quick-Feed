//
//  DetailVC.swift
//  Quick Feed
//
//  Created by AK on 4/12/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit

class DetailVC: UIViewController{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var cookingTime: UILabel!
    @IBOutlet weak var cuisine: UILabel!
    
    static var nameString = ""
    static var caloriesString = ""
    static var cookingTimeString = ""
    static var cuisineString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = DetailVC.nameString
        print(DetailVC.nameString)
        calories.text = "Calories: " + DetailVC.caloriesString
        cookingTime.text = "Cooking Time: " + DetailVC.cookingTimeString
        cuisine.text = "Cuisine: " + DetailVC.cuisineString
        self.navigationItem.hidesBackButton = false
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(DetailVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        
        
    }
    
    @IBAction func favPressed(_ sender: Any) {
        FavoriteVC.favoriteArray.append(Recipe(recipeID: "", name: DetailVC.nameString, calories: DetailVC.caloriesString, cookingTime: DetailVC.cookingTimeString, cuisine: DetailVC.cuisineString, lifeStyleID: ""))
       // self.goTo("FavoriteVC", animate: true)
        alert(title: "Added to favorites", message: "done")
        
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        //self.goTo("TabBarVC", animate: true)
    }
    //Text Alert
    func alert(title: String, message: String) {
        
        //Error Title
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //Action Title
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //Presnt to Screen
        present(alert,animated: true, completion: nil)
        //Try to save entire array and bring it back using User Defaults
        
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
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
}
