//
//  MyFriendsController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 01.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class MyFriendsController: UITableViewController {

      //  var myFriends = [String]()
        
        let vKService = VKService()
        var getMyFriends = [GetMyFriends]()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            vKService.loadVKAnyFriends(vKId: vKService.myVkId) { [weak self] getMyFriends in
                self?.getMyFriends = getMyFriends
                self?.tableView?.reloadData()
            }
            
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem
        }
        
        
        // MARK: - Table view data source
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return getMyFriends.count
        }
        
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyFriendsCell", for: indexPath) as! MyFriendsCell
            
            let friends = getMyFriends[indexPath.row]
            
            cell.myFriendLabel.text = friends.friendFullName
            
            cell.idFriend = getMyFriends[indexPath.row].friendId
            
            cell.myFriendOnlineStatus.layer.masksToBounds = true
            cell.myFriendOnlineStatus.image = UIImage(named: friends.frindsOnlineStatus)
            cell.myFriendOnlineStatus.layer.cornerRadius = 5
            
            cell.myFriendImage.layer.masksToBounds = true
            cell.myFriendImage?.setImageFromURL(stringImageUrl: friends.friendPhoto50)
            cell.myFriendImage.layer.cornerRadius = 25
            
            return cell
        }
        
        /*
         // Override to support conditional editing of the table view.
         override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
         }
         */
        
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                getMyFriends.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMyFrend" {
            
            let cell = sender as! MyFriendsCell
            
            let selectedFrend = getMyFriends.filter({ $0.friendId == cell.idFriend
            })
            
            if selectedFrend.count == 0 {
                fatalError()
            }
            let fotoMyFrendCollectionViewController = segue.destination as! VKViewController
            fotoMyFrendCollectionViewController.fullName = selectedFrend[0].friendFullName
            
            fotoMyFrendCollectionViewController.bigPhotoURL = selectedFrend[0].friendPhoto50
            
        }
    }
    
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
