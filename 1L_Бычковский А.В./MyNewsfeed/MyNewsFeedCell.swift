//
//  Newsfeedcell.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 19.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class MyNewsFeedCell: UITableViewCell {
    @IBOutlet weak var titlePostPhoto: UIImageView!
    @IBOutlet weak var titlePostLabel: UILabel!
    @IBOutlet weak var titlePostOnlineStatus: UILabel!
    
    @IBOutlet weak var newsFeedImage: UIImageView!
    @IBOutlet weak var newsFeedLabel: UILabel!
    
    
    @IBOutlet weak var newsFeedImageWidth: NSLayoutConstraint!
    @IBOutlet weak var newsFeedImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
