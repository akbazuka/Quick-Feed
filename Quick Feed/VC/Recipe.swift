//
//  recipe.swift
//  Quick Feed
//
//  Created by AK on 4/10/19.
//  Copyright © 2019 Kedlena. All rights reserved.
//
import UIKit

struct RecipeStruct: Codable {
    
    let recipeID: String
    let name: String
    let calories: String
    let cookingTime: String
    let cuisine: String
    //let image: String
    let directions: String
    let lifeStyleID: String
    enum CodingKeys: String, CodingKey {
        case recipeID = "RecipeID"
        case name = "RecipeName"
        case calories = "Calories"
        case cookingTime = "CookingTime"
        case cuisine = "Cuisine"
        //case image = "Image"
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
    //var image: String
    
    init(recipeID: String, name: String, calories: String, cookingTime: String, cuisine: String, lifeStyleID: String, directions: String/*, image: String*/){
        self.recipeID = recipeID
        self.name = name
        self.calories = calories
        self.cookingTime = cookingTime
        self.cuisine = cuisine
        self.directions = directions
        self.lifeStyleID = lifeStyleID
        //self.image = image
    }
}


