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
    
    /*class func getRecipes(ingredients : String, completion :@escaping ([Recipe]) -> Void){
        var recipes = [Recipe]()
        for i in 1..<6
        {
            Alamofire.request(website + ingredients + "&p=\(i)").responseJSON {response in
                if let JSON = response.result.value as? NSDictionary,
                    let results = JSON["results"] as? NSArray{
                    print(website + ingredients + "&p=\(i)")
                    for i in 0..<results.count {
                        if let res = results[i] as? [String:String] {
                            if var title = res["title"] {
                                title = String(title.characters.filter { !"\n\t\r".characters.contains($0) })
                                if let thumbnailLink = res["thumbnail"] {
                                    recipes.append(Recipe(title: title, thumbnail: thumbnailLink, link: res["href"] ?? "", ingredients: res["ingredients"] ?? ""))
                                }
                                if (i==5){
                                    completion(recipes)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    */
}


