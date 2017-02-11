//
//  Recipe_VC.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/1/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit

class Recipe_VC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var recipes = [Recipe]()
    var clickedUrl : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecipePuppy.getRecipes(ingredients: "garlic,onion,cheese,eggs") { (result) in
            self.recipes = result
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? RecipeWebView_VC {
            destinationVC.url = clickedUrl
        }
    }
    
}

//MARK: UITableView Delegate and Data Source Methods 
extension Recipe_VC : UITableViewDataSource, UITableViewDelegate   {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! RecipeCell
        cell.titleLabel.text = recipes[indexPath.row].title
        cell.ingrediantLabel.text = recipes[indexPath.row].ingredients
        if let thumbnailData = recipes[indexPath.row].thumbnail {
            cell.imageThumbnail.image = UIImage(data: thumbnailData)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedUrl = recipes[indexPath.row].link
        self.performSegue(withIdentifier: "goToWebView", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
}
