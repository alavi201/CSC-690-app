//
//  SearchCell.swift
//  Twitter-Clone
//
//  Created by Vipul Karanjkar on 5/11/19.
//  Copyright © 2019 SFSU. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
