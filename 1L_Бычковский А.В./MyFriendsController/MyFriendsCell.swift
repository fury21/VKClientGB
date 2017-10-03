//
//  MyFriendsCell.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 01.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class MyFriendsCell: UITableViewCell {
    
    var idFriend: Int!
    
    @IBOutlet weak var myFriendImage: UIImageView!
    @IBOutlet weak var myFriendLabel: UILabel!
    @IBOutlet weak var myFriendOnlineStatus: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
