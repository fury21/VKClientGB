//
//  AllGroupsCellTableViewCell.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 20.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
