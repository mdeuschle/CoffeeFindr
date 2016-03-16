//
//  TableViewCell.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/15/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var milesLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
