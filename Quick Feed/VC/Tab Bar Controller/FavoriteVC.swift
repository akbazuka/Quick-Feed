//
//  FavoriteVC.swift
//  Quick Feed
//
//  Created by AK on 4/12/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    static var favoriteArray: [Favorites] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pullFavData { (success) -> Void in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
    }
    
    
    //Pulls user data from PHP file
    func pullFavData(completion: @escaping (_ success: Bool) -> Void) {
        FavoriteVC.favoriteArray = []
        let uID = UserDefaults.standard.string(forKey: "uID") ?? "-1"
        let url = URL(string: SignUpVC.dataURL + "pullFav&uID=\(uID)")
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {print(error!); return}
            let decoder = JSONDecoder()
            let favClasses = try! decoder.decode([FavStruct].self, from: data)
            for favorites in favClasses{
                FavoriteVC.favoriteArray.append(Favorites(recipeID: favorites.recipeID,
                                                          name: favorites.name,
                                                          calories: favorites.calories,
                                                          cookingTime: favorites.cookingTime,
                                                          cuisine: favorites.calories,
                                                          directions: favorites.directions))
            }
            completion(true)
        }).resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteVC.favoriteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = FavoriteVC.favoriteArray[indexPath.row].name 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetailVC.nameString = FavoriteVC.favoriteArray[indexPath.row].name
        DetailVC.caloriesString = FavoriteVC.favoriteArray[indexPath.row].calories
        DetailVC.cookingTimeString = FavoriteVC.favoriteArray[indexPath.row].cookingTime
        DetailVC.cuisineString = FavoriteVC.favoriteArray[indexPath.row].cuisine
        DetailVC.directionsString = FavoriteVC.favoriteArray[indexPath.row].directions
        DetailVC.recipeID = FavoriteVC.favoriteArray[indexPath.row].recipeID
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
    
}
