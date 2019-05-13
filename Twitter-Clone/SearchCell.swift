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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let title = cellButton.titleLabel!.text as! String
        
        if (title == "Follow") {
            print("follow")
        } else {
            print("unfollow")
        }
        
    }

}