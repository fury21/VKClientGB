//
//  NewsfeedViewController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 19.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class MyNewsfeedController: UITableViewController {
    
    let vKService = VKService()
    var getMyNewsFeed: [GetMyNewsFeed]? //: Results<GetMyNewsFeed>?
    
    var notificationToken: NotificationToken?
    
    let maxScreenWidth = UIScreen.main.bounds.width
    
    

    
    @IBAction func newsFeedRefreshButton(_ sender: Any) {
        //        vKService.loadVKFeedNews()
        
        vKService.loadVKFeedNews() { [weak self] completion in
            self?.getMyNewsFeed = completion
            self?.tableView?.reloadData()
        }
    }
    

    
  
    func photoResizer(indexPathRow i: Int) -> (w: CGFloat, h: CGFloat) {
        var photoSize = getMyNewsFeed![i].attachments_photoSize.components(separatedBy: "x")
        
        if Float(photoSize[0])! > Float(maxScreenWidth) {
            
            let imgRatio = Float(photoSize[0])! / Float(maxScreenWidth)
            let newHeight = Float(photoSize[1])! / imgRatio
            
            return (maxScreenWidth, CGFloat(ceil(newHeight)))
        } else {
            return (CGFloat(
                Float(photoSize[0])!), CGFloat(Float(photoSize[1])!))
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   pairTableAndRealm()
        
        
        vKService.loadVKFeedNews() { [weak self] completion in
            self?.getMyNewsFeed = completion
            self?.tableView?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getMyNewsFeed?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyNewsFeedCell", for: indexPath) as! MyNewsFeedCell
        
        guard let newsFeed = getMyNewsFeed?[indexPath.row] else {
            cell.textLabel?.text = ""
            return cell
        }
        
        cell.delegateButton = self
        cell.indexPathCell = indexPath
        
        
        if !newsFeed.attachments_typePhoto.isEmpty {
            cell.newsFeedImageWidth.constant = self.photoResizer(indexPathRow: indexPath.row).w
            cell.newsFeedImageHeight.constant = self.photoResizer(indexPathRow: indexPath.row).h
            
//            DispatchQueue.global(qos: .userInteractive).async {
//            cell.newsFeedImage.setImageFromURL(stringImageUrl: newsFeed.attachments_typePhoto)
//            }
//
           cell.newsFeedImage.sd_setImage(with: URL(string: newsFeed.attachments_typePhoto), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed]) //, completed: {(image, _, _, _) in })
        } else {
            cell.newsFeedImageHeight.constant = 0
            //            cell.newsFeedImage.image = nil
        }
        
        
        cell.titlePostOnlineStatus.text = self.vKService.timeAgo(time: newsFeed.titlePostTime)
        
        
        if newsFeed.postText.isEmpty {
            cell.newsFeedLabel.text = ""
        } else {
            cell.newsFeedLabel.text = newsFeed.postText
        }
        
        if !newsFeed.titlePostPhoto.isEmpty {
            cell.titlePostPhoto.sd_setImage(with: URL(string: newsFeed.titlePostPhoto), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed]) 
        } else {
            cell.titlePostPhoto.image = nil
        }
        cell.titlePostLabel.text = newsFeed.titlePostLabel
        
        
        cell.titlePostPhoto.layer.masksToBounds = true
        cell.titlePostPhoto.layer.cornerRadius = cell.titlePostPhoto.frame.size.height / 2
        
        // лайки, комменты, шары, просмотры
        
        if newsFeed.userLikes == 1 {
//        cell.likeIco.image = UIImage(named: "ic_liked_24dp_Normal")
            cell.likeButtonOutlet.setImage(UIImage(named: "ic_liked_24dp_Normal"), for: .normal)
            cell.likeLabel.textColor = UIColor(red: 254/255, green: 0/255, blue: 41/255, alpha: 1)
        } else {
//        cell.likeIco.image = UIImage(named: "ic_like_24dp_Normal")
            cell.likeButtonOutlet.setImage(UIImage(named: "ic_like_24dp_Normal"), for: .normal) 
            cell.likeLabel.textColor = UIColor(red: 102/255, green: 110/255, blue: 118/255, alpha: 1)
        }
        
        cell.likeLabel.text = vKService.roundViews(count: newsFeed.likesCount)
        
        if newsFeed.commentCanPost == 1 {
        cell.commentLabel.text = vKService.roundViews(count: newsFeed.commentsCount)
        } else {
            cell.commentIcoWidth.constant = 0
            cell.commentLabelWidth.constant = 0
            cell.commentLedingConstraint.constant = 0
        }
        cell.repostLabel.text = vKService.roundViews(count: newsFeed.repostsCount)
        cell.viewersLabel.text = vKService.roundViews(count: newsFeed.viwesCount)
        
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    //    func pairTableAndRealm() {
    //        guard let realm = try? Realm() else { return }
    //        getMyNewsFeed = realm.objects(GetMyNewsFeed.self)
    //
    //        notificationToken = getMyNewsFeed?.observe { [weak self] (changes: RealmCollectionChange) in
    //            guard let tableView = self?.tableView else { return }
    //
    //            switch changes {
    //            case .initial:
    //                tableView.reloadData()
    //            case .update(_, let deletions, let insertions, let modifications):
    //                tableView.beginUpdates()
    //                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
    //                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
    //                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
    //                tableView.endUpdates()
    //                break
    //            case .error(let error):
    //                fatalError("\(error)")
    //                break
    //            }
    //        }
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension MyNewsfeedController: CellForButtonsDelegate {

    func didTapCompleteButton(indexPath: IndexPath) {
        if getMyNewsFeed![indexPath.row].userLikes == 0 {
        vKService.addOrDeleteLike(likeType: .post, owner_id: getMyNewsFeed![indexPath.row].postSource_id, item_id: getMyNewsFeed![indexPath.row].post_id , action: .addLike)
           
            getMyNewsFeed![indexPath.row].userLikes = 1
        } else {
            vKService.addOrDeleteLike(likeType: .post, owner_id: getMyNewsFeed![indexPath.row].postSource_id, item_id: getMyNewsFeed![indexPath.row].post_id , action: .deleteLike)
           
            getMyNewsFeed![indexPath.row].userLikes = 0
        }
    }}
