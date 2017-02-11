//
//  RecipePuppy.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import Foundation
import Alamofire

class RecipePuppy {
  
    static var website = "http://www.recipepuppy.com/api/?i="
    
    class func getRecipes(ingredients : String, completion :@escaping ([Recipe]) -> Void){
        var recipes = [Recipe]()
        Alamofire.request(website + ingredients).responseJSON {response in
            if let JSON = response.result.value as? NSDictionary,
                let results = JSON["results"] as? NSArray{
                for i in 0..<results.count {
                    if let res = results[i] as? [String:String] {
                        if var title = res["title"] {
                        title = String(title.characters.filter { !"\n\t\r".characters.contains($0) })
                        recipes.append(Recipe(title: title, thumbnail: res["thumbnail"] ?? "", link: res["href"] ?? "", ingredients: res["ingredients"] ?? ""))
                        }
                    }
                }
                completion(recipes)
            }
        }
        
    }
    
}


struct Recipe {
    var title: String
    var thumbnail : Data?
    var link: URL?
    var ingredients: String
    
    init(title: String, thumbnail: String, link: String, ingredients: String) {
        self.title = title
        self.link = URL(string: link)
        self.ingredients = ingredients
        if let thumbnailUrl = URL(string: thumbnail) {
            do {
                self.thumbnail = try Data(contentsOf: thumbnailUrl)
            } catch {
                print("error with img")
            }
        }

    }
}
