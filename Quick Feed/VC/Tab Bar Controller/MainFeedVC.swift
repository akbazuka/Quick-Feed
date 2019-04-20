//
//  MainFeedVC.swift
//  Quick Feed
//
//  Created by AK on 3/22/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit

class MainFeedVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //Declare Recipe array to store recipes pulled from database
    var recipeArray : [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello")
        startIndicator() //Starts progress indicator
        
        //Load user data first to get correct lifestyle ID
        pullUserData { (success) -> Void in
            if success{
                    //Load feed data based on correctr lifestyle ID that was loaded
                    self.pullFeedData { (_ data: [Recipe]) in
                        DispatchQueue.main.async {
                            self.recipeArray = data
                            self.collectionView.reloadData()
                            self.stopIndicator() //Stop animating progress indicator
                        }
                    }
                    
                
                
            }
        }
    }
    
    //Starts animating progress indicator
    func startIndicator(){
        indicator.startAnimating()
        indicator.isHidden = false
        
    }
    //Stops animating progress indicator
    func stopIndicator(){
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    //Pulls user data from PHP file
    func pullUserData(completion: @escaping (_ success: Bool) -> Void) {
            let uID = UserDefaults.standard.string(forKey: "uID") ?? "-1"
            print("UID \(uID)")
            let url = URL(string:"http://quickfeed.net/quickFeedService1.php?type=pullUser&uID=\(uID)")
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else {print(error!); return}
                let decoder = JSONDecoder()
                let userClasses = try! decoder.decode([UserStruct].self, from: data)
                for user in userClasses{
                    print("STUFF \(user.lifestyleID)")
                    //Save new lifestyle ID

                    UserDefaults.standard.set(user.lifestyleID, forKey: "lifestyle")
                }
                completion(true)
            }).resume()
    }

    //Pulls feed data from php file
    func pullFeedData(_ callBack: @escaping ([Recipe]) -> ()) {
            var recipeArray : [Recipe] = []
            let savedLifestyleID = UserDefaults.standard.string(forKey: "lifestyle") ?? "5"
            print("Lifestyle \(savedLifestyleID)")
            let url = URL(string:"http://quickfeed.net/quickFeedService1.php?type=pullRecipes&lifestyleID=\(savedLifestyleID)")
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else {print(error!); return}
                let decoder = JSONDecoder()
                let classes = try! decoder.decode([RecipeStruct].self, from: data)
                for recipe in classes {
                    recipeArray.append(Recipe(recipeID: recipe.recipeID, name: recipe.name, calories: recipe.calories, cookingTime: recipe.cookingTime, cuisine: recipe.cuisine, lifeStyleID: recipe.lifeStyleID, directions: recipe.directions/*, image: recipe.image*/))
                }
                callBack(recipeArray)
            }).resume()
    }

    
    //Counts number of items in Recipe Array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainFeedViewCell
        //Rounds Cell's Corners
        cell.layer.cornerRadius = 10.0
        
        cell.recipeName.text = recipeArray[indexPath.row].name
        cell.recipeName.font = UIFont(name: "LaoSangamMN", size: 18)
        
        cell.recipeCalories.text = "Calories: " + recipeArray[indexPath.row].calories
        cell.recipeCalories.font = UIFont(name: "LaoSangamMN", size: 18)
        
        cell.recipeCookingTime.text = "Time: " + recipeArray[indexPath.row].cookingTime
        cell.recipeCookingTime.font = UIFont(name: "LaoSangamMN", size: 18)
        
        cell.recipeCuisine.text = "Cuisine: " + recipeArray[indexPath.row].cuisine
        cell.recipeCuisine.font = UIFont(name: "LaoSangamMN", size: 18)
        
        //cell.recipeImage.image = loadURLImage(recipeArray[indexPath.row].image)
        
        return cell
    }
    
    //Collection View on Main Feed to show each recipe
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = recipeArray[indexPath.row]
        DetailVC.nameString = cell.name
        DetailVC.caloriesString = cell.calories
        DetailVC.cookingTimeString = cell.cookingTime
        DetailVC.cuisineString = cell.cuisine
        DetailVC.directionsString = cell.directions
        DetailVC.recipeID = cell.recipeID
        goTo("DetailVC", animate: true)
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
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Use indexPath.row
        //Use goTo method to go to controller
    }*/
    
}
