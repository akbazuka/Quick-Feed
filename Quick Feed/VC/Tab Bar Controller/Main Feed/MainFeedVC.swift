//
//  MainFeedVC.swift
//  Quick Feed
//
//  Created by AK on 3/22/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit
import Alamofire

class MainFeedVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource/*, UISearchBarDelegate, UISearchResultsUpdating*/{
    
    /* Search 3
    func updateSearchResults(for searchController: UISearchController) {
     
    }
 */
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var searchController: UISearchController!
    
    //Declare Recipe array to store recipes pulled from database
    var recipeArray : [Recipe] = []
    
    /*//Variables to implement Search 2
    var filtered:[Recipe] = []
    var searchActive : Bool = false
    let searchController = UISearchController(searchResultsController: nil)*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicator() //Starts progress indicator
        
        //Load user data first to get correct lifestyle ID
        pullUserData { (success) -> Void in
            print("Testing*", success)
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
        
        /*
        //Search Bar 3
        func configureSearchController() {
            searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = true
            searchController.searchBar.placeholder = "Search"
            searchController.searchBar.delegate = self
            searchController.searchBar.sizeToFit()
            
        }*/
        
        /*
        //Search Bar
        self.searchController.searchResultsUpdater = (self as! UISearchResultsUpdating) //Could not cast value of QFVC
        self.searchController.delegate = (self as! UISearchControllerDelegate)
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for tools and resources"
        searchController.searchBar.sizeToFit()
        
        searchController.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = searchController.searchBar*/
    }
    
    //Search bar collection view, Returns UICollectionReusable View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath)
            
            return headerView
        }
        
        return UICollectionReusableView()
        
    }
    
    /* Search Bar 1
     //MARK: - SEARCH
     //Search bar Delegate Method
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            //reload your data source if necessary
            self.collectionView?.reloadData()
        }
     }
     //Search Bar Delegate Method
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            //reload your data source if necessary
            self.collectionView?.reloadData()
        }
     }
 */
    
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

                    //UserDefaults.standard.set(user.lifestyleID, forKey: "lifestyle")
                    LifestyleVC.saveLifeStyle()
                }
                completion(true)
            }).resume()
    }

    //Pulls feed data from php file
    func pullFeedData(_ callBack: @escaping ([Recipe]) -> ()) {
            var recipeArray : [Recipe] = []
            let savedLifestyleID = UserDefaults.standard.string(forKey: "lifestyle") ?? "1"
            //let savedLifestyleID = LifestyleVC.loadLifestyle()
            print("Lifestyle \(savedLifestyleID)")
            let url = URL(string:"http://quickfeed.net/quickFeedService1.php?type=pullRecipes&lifestyleID=\(savedLifestyleID)")
            URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else {print(error!); return}
                let decoder = JSONDecoder()
                let classes = try! decoder.decode([RecipeStruct].self, from: data)
                for recipe in classes {
                    let pulledRecipe = Recipe(recipeID: recipe.recipeID, name: recipe.name, calories: recipe.calories, cookingTime: recipe.cookingTime, cuisine: recipe.cuisine, lifeStyleID: recipe.lifeStyleID, directions: recipe.directions, imageURL: recipe.image, completion:{ () in
                            self.collectionView.reloadData()
                        })
                    recipeArray.append(pulledRecipe)
                }
                callBack(recipeArray)
            }).resume()
    }
    
    //Pull Image
    

    //Counts number of items in Recipe Array
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*//Search 2
        if searchActive {
            return filtered.count
        }
        else
        {
            return recipeArray.count
        }*/
        return recipeArray.count //If search inactive
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
        
        if let pulledImg = recipeArray[indexPath.row].pulledImg {
            cell.recipeImage.image = pulledImg
        }
        
        /*//Image
        Alamofire.request(recipeArray[indexPath.row].image).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    cell.recipeImage.image = UIImage(data:data)
                }
            }
        }
 */
        return cell
    }
    
    /* Seacrh 2
    //MARK: Search Bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchString = searchController.searchBar.text
        
        filtered = recipeArray.filter({ (recipe) -> Bool in
            let countryText: NSString = recipe.name as NSString
            
            return (countryText.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        collectionView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        collectionView.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            collectionView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
 */
    
    //Collection View on Detail VC to show each recipe
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = recipeArray[indexPath.row]
        DetailVC.nameString = cell.name
        DetailVC.caloriesString = cell.calories
        DetailVC.cookingTimeString = cell.cookingTime
        DetailVC.cuisineString = cell.cuisine
        DetailVC.directionsString = cell.directions
        DetailVC.recipeID = cell.recipeID
        
        DetailVC.image1 = cell.pulledImg
        self.goTo("DetailVC", animate: true)
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
