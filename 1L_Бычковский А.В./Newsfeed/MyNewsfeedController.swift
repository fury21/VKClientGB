//
//  NewsfeedViewController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 19.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import RealmSwift

class MyNewsfeedController: UITableViewController {

    let vKService = VKService()
    var getMyNewsFeed: Results<GetMyNewsFeed>?
    
    var notificationToken: NotificationToken?

    @IBAction func newsFeedRefreshButton(_ sender: Any) {
        vKService.loadVKFeedNews()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.estimatedRowHeight = 180 // примерная высота ячейки
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        pairTableAndRealm()
        
        vKService.loadVKFeedNews()
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
        
        if newsFeed.attachments_typePhoto.lowercased().range(of: "http") != nil {
         cell.newsFeedImage?.setImageFromURL(stringImageUrl: newsFeed.attachments_typePhoto)
           
            let imgWidth = cell.newsFeedImage.image!.size.width
            let imgHeight = cell.newsFeedImage.image!.size.height
            let imgRatio = Int(imgWidth) / Int(imgHeight)
            
            let maxScreenWidth = UIScreen.main.bounds.width - 0 // граница по краям

            cell.newsFeedImageWidth.constant = maxScreenWidth
            cell.newsFeedImageHeight.constant = CGFloat(Int(maxScreenWidth) * Int(imgRatio))
            
            cell.newsFeedImage?.setImageFromURL(stringImageUrl: newsFeed.attachments_typePhoto)
        } else {
            cell.newsFeedImageHeight.constant = 0
            cell.newsFeedImage.image = nil
        }
        cell.titlePostOnlineStatus.text = vKService.timeAgo(time: newsFeed.titlePostTime)
        
        if newsFeed.postText == "" {
              cell.newsFeedLabel.text = ""
        } else {
            cell.newsFeedLabel.text = newsFeed.postText
        }
        
        if newsFeed.titlePostPhoto.lowercased().range(of: "http") != nil {
            cell.titlePostPhoto?.setImageFromURL(stringImageUrl: newsFeed.titlePostPhoto)
        } else {
            cell.titlePostPhoto.image = nil
        }
        cell.titlePostLabel.text = newsFeed.titlePostLabel
        
        
        cell.titlePostPhoto.layer.masksToBounds = true
        cell.titlePostPhoto.layer.cornerRadius = cell.titlePostPhoto.frame.size.height / 2
        
        
        return cell
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        getMyNewsFeed = realm.objects(GetMyNewsFeed.self)
        
        notificationToken = getMyNewsFeed?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
             tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
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
