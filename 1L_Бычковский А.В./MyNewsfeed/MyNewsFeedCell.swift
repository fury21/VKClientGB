//
//  Newsfeedcell.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 19.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

protocol CellForButtonsDelegate {
    func didTapCompleteButton(indexPath: IndexPath)
}

class MyNewsFeedCell: UITableViewCell {
    
    let vKService = VKService()
    var getMyNewsFeed: [GetMyNewsFeed]? //: Results<GetMyNewsFeed>?
    
    
    @IBOutlet weak var titlePostPhoto: UIImageView!
    @IBOutlet weak var titlePostLabel: UILabel!
    @IBOutlet weak var titlePostOnlineStatus: UILabel!
    
    @IBOutlet weak var newsFeedImage: UIImageView!
    @IBOutlet weak var newsFeedLabel: UILabel!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    
    @IBOutlet weak var commentIco: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentIcoWidth: NSLayoutConstraint!
    @IBOutlet weak var commentLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var commentLedingConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var geoIcon: UIImageView!
    @IBOutlet weak var geoLabel: UILabel!
    @IBOutlet weak var geoIconHeight: NSLayoutConstraint!
    @IBOutlet weak var geoLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var geoIconTopHeight: NSLayoutConstraint!
    @IBOutlet weak var geoLabelTopHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    var delegateButton: CellForButtonsDelegate?
    var indexPathCell: IndexPath?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func likeButtonAction(_ sender: Any) {
        delegateButton?.didTapCompleteButton(indexPath: indexPathCell!)
        
        
        if likeButtonOutlet.currentImage == UIImage(named: "ic_like_24dp_Normal") {
            likeButtonOutlet.setImage(UIImage(named: "ic_liked_24dp_Normal"), for: .normal)
            likeLabel.textColor = UIColor(red: 254/255, green: 0/255, blue: 41/255, alpha: 1)
            
            if let likesTest = Int(likeLabel.text!) {
             if likesTest < 1000 { likeLabel.text = String(Int(likeLabel.text!)! + 1) }
            }
        } else {
            likeButtonOutlet.setImage(UIImage(named: "ic_like_24dp_Normal"), for: .normal)
            likeLabel.textColor = UIColor(red: 102/255, green: 110/255, blue: 118/255, alpha: 1)
            if let likesTest = Int(likeLabel.text!) {
                if likesTest < 1000 { likeLabel.text = String(Int(likeLabel.text!)! - 1) }
            }
        }
    }

    
    @IBOutlet weak var repostIco: UIImageView!
    @IBOutlet weak var repostLabel: UILabel!
    
    @IBOutlet weak var viewersIco: UIImageView!
    @IBOutlet weak var viewersLabel: UILabel!
    
    
    
    @IBOutlet weak var newsFeedImageWidth: NSLayoutConstraint!
    @IBOutlet weak var newsFeedImageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
