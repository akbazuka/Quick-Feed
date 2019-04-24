//
//  recipe.swift
//  Quick Feed
//
//  Created by AK on 4/10/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//
import UIKit
import Alamofire

struct RecipeStruct: Codable {
    
    let recipeID: String
    let name: String
    let calories: String
    let cookingTime: String
    let cuisine: String
    let image: String
    let directions: String
    let lifeStyleID: String
    enum CodingKeys: String, CodingKey {
        case recipeID = "RecipeID"
        case name = "RecipeName"
        case calories = "Calories"
        case cookingTime = "CookingTime"
        case cuisine = "Cuisine"
        case image = "Image"
        case directions = "Directions"
        case lifeStyleID = "LifeStyleID"
    }
}

class Recipe{
    
    var recipeID : String
    var name :String
    var calories : String
    var cookingTime: String
    var cuisine: String
    var directions: String
    var lifeStyleID: String
    var imageURL: String
    var pulledImg: UIImage? = nil
    
    init(recipeID: String, name: String, calories: String, cookingTime: String, cuisine: String, lifeStyleID: String, directions: String, imageURL: String, completion: @escaping () -> Void){
        self.recipeID = recipeID
        self.name = name
        self.calories = calories
        self.cookingTime = cookingTime
        self.cuisine = cuisine
        self.directions = directions
        self.lifeStyleID = lifeStyleID
        self.imageURL = imageURL
        
        pullImage(URL: imageURL) { (_ image: UIImage?) in
            self.pulledImg = image
            completion()
        }
    }
    
    //Pulls image with Alamofire
    func pullImage(URL: String, completion: @escaping (_ image: UIImage?) -> Void){
        Alamofire.request(URL).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if let data = response.data {
                    completion(UIImage(data:data))
                    return
                }
            }
            completion(nil)
        }
    }
}


