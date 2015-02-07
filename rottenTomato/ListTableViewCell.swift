//
//  ListTableViewCell.swift
//  rottenTomato
//
//  Created by Hao Wang on 2/5/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelScore2: UILabel!
    @IBOutlet weak var labelScore1: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
