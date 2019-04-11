//
//  MainFeedVC.swift
//  Quick Feed
//
//  Created by AK on 3/22/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

import UIKit

class MainFeedVC : UIViewController{
    
    var recipeArray : [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let url = URL(string:"http://quickfeed.net/quickFeedService1.php")
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else {print(error!); return}

            let decoder = JSONDecoder()
            let classes = try! decoder.decode([RecipeStruct].self, from: data)
            
            //
            for recipe in classes {
                self.recipeArray.append(Recipe(recipeID: recipe.recipeID, name: recipe.name, calories: recipe.calories, cookingTime: recipe.cookingTime, cuisine: recipe.cuisine))
            }

        }).resume()
    }
}
