//
//  MyGroupsCell.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 22.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {

    @IBOutlet weak var myGroupLabel: UILabel!
    @IBOutlet weak var myGroupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
