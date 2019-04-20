//
//  Favorite.swift
//  Quick Feed
//
//  Created by Zachary Kline on 4/19/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//

struct FavStruct: Codable {
    let recipeID: String
    let name: String
    let calories: String
    let cookingTime: String
    let cuisine: String
    let directions: String
    enum CodingKeys: String, CodingKey {
        case recipeID = "RecipeID"
        case name = "RecipeName"
        case calories = "Calories"
        case cookingTime = "CookingTime"
        case cuisine = "Cuisine"
        case directions = "Directions"
    }
}

class Favorites{
    var recipeID : String
    var name :String
    var calories : String
    var cookingTime: String
    var cuisine: String
    var directions: String
    
    init(recipeID: String, name: String, calories: String, cookingTime: String, cuisine: String, directions: String){
        self.recipeID = recipeID
        self.name = name
        self.calories = calories
        self.cookingTime = cookingTime
        self.cuisine = cuisine
        self.directions = directions
    }
}
