//
//  PhotoDataCell.swift
//  FridgeView
//
//  Created by Ben Cootner on 2/27/17.
//  Copyright © 2017 Ben Cootner. All rights reserved.
//

import UIKit
import ParseUI

class PhotoDataCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var mainImage: PFImageView!
    @IBOutlet weak var dateLabel: UILabel!
}
