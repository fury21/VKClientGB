//
//  File.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 06.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//


import UIKit

class MyMessagesCell: UITableViewCell {
    
    @IBOutlet weak var friendPhoto: UIImageView!
    @IBOutlet weak var friendFullName: UILabel!
    @IBOutlet weak var myLittlePhoto: UIImageView!
    @IBOutlet weak var lastMessages: UILabel!
    @IBOutlet weak var unreadStatus: UIView!
    @IBOutlet weak var messageTime: UILabel!
    
    @IBOutlet weak var bigImgConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

