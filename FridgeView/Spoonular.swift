//
//  Spoonular.swift
//  FridgeView
//
//  Created by Ben Cootner on 3/25/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Alamofire

class Spoonular{
    
    class func getRecipes(ingredients : String, completion : @escaping (([Recipe]) -> Void)) {
        
        var recipes = [Recipe]()
        
        let headers: HTTPHeaders = [
            "X-Mashape-Key": "4VRY1CkceQmshdVH8sqMiStrzOpYp1LueT9jsnbpwpHPJCmAJz",
            "Accept": "application/json"
        ]
    
        Alamofire.request("https://spoonacular-recipe-food-nutrition-v1.p.mashape.com/recipes/findByIngredients?fillIngredients=false&ingredients=\(ingredients)&limitLicense=false&number=20&ranking=2", headers: headers).responseJSON { response in
            if let results = response.result.value as? NSArray {
                for i in 0..<results.count {
                    if let res = results[i] as? NSDictionary {
                        let id = res["id"] ?? 0
                        let title = res["title"] ?? ""
                        let image = res["image"] ?? ""
                        let link = "https://spoonacular.com/recipes/\((title as! String).replacingOccurrences(of: " ", with: "-"))-\(id)"
                        let usedCount = res["usedIngredientCount"] ?? 0
                        let missingCount = res["missedIngredientCount"] ?? 0
                        let newRecipe = Recipe(id: id as! Int,
                                               title:  title as! String,
                                               thumbnail: image as! String,
                                               link: link ,
                                               usedIngredientCount: usedCount as! Int,
                                               missingIngredientCount: missingCount as! Int)
                     
                    recipes.append(newRecipe)
                    }
                }
                completion(recipes)
            }
        }
    }

}

struct Recipe {
    var id : Int?
    var title: String
    var thumbnail : Data?
    var link: URL?
    var usedIngredientCount: Int?
    var missingIngredientCount: Int?

    
    init(id: Int, title: String, thumbnail: String, link: String, usedIngredientCount: Int, missingIngredientCount: Int) {
        self.id = id
        self.title = title
        self.link = URL(string: link)
        self.usedIngredientCount = usedIngredientCount
        self.missingIngredientCount = missingIngredientCount
        if let thumbnailUrl = URL(string: thumbnail) {
            do {
                self.thumbnail = try Data(contentsOf: thumbnailUrl)
            } catch {
                print("error with img")
            }
        }
        
    }
}


