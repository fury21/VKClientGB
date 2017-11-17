//
//  MessagesController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 02.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import RealmSwift

class MyMessagesController: UITableViewController {
    
    let vKService = VKService()
    var getMyMessages: Results<GetMyMessages>?
    
    var notificationToken: NotificationToken?

    @IBAction func messageRefreshButton(_ sender: Any) {
            vKService.loadVKDialogs()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pairTableAndRealm()
        
        vKService.loadVKDialogs()
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
        return getMyMessages?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessagesCell", for: indexPath) as! MyMessagesCell

        guard let messages = getMyMessages?[indexPath.row] else {
            cell.textLabel?.text = ""
            return cell
        }
        
        
        
        if messages.userId > 0 { // не группа
            cell.friendPhoto.sd_setImage(with: URL(string: messages.friendPhoto), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed])
            
            cell.friendFullName.text = messages.friendfullName
        } else {
            cell.friendPhoto.sd_setImage(with: URL(string: messages.groupPhoto), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed])
            
            cell.friendFullName.text = messages.groupName
        }
        
        
        cell.myLittlePhoto.sd_setImage(with: URL(string: messages.currentUserMiniPhoto), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed])
        

        cell.messageTime.text = vKService.vkMessagesDateFormatter(messageDate: messages.date)

        cell.lastMessages.text = messages.body

        
        // Не понятно как определить что последнее сообщение в диалогах от меня...
//        if messages.userId == vKService.userVkId {
//            //cell.myLittlePhoto.image = nil
//            cell.bigImgConstrain.constant = 0
//            print("NO!!!!")
//        } else {
//            print("YES!!!")
//            cell.bigImgConstrain.constant = 25
//        }
        
        if messages.read_state == 0 { // не прочитано собеседником
            cell.unreadStatus.backgroundColor = UIColor(red: 236/255, green: 242/255, blue: 246/255, alpha: 1)
        } else {
            cell.unreadStatus.backgroundColor = UIColor.white
//            cell.myLittlePhoto.image = nil
        }
        
        if messages.unread > 0 {
            cell.unreadStatus.backgroundColor = UIColor(red: 236/255, green: 242/255, blue: 246/255, alpha: 1)
            cell.backgroundColor = UIColor(red: 236/255, green: 242/255, blue: 246/255, alpha: 1)
        } else {
//            cell.unreadStatus.backgroundColor = UIColor.white
            cell.backgroundColor = UIColor.white
        }
        
        
        cell.friendPhoto.layer.masksToBounds = true
        cell.friendPhoto.layer.cornerRadius = cell.friendPhoto.frame.size.height / 2
        
        cell.myLittlePhoto.layer.masksToBounds = true
        cell.myLittlePhoto.layer.cornerRadius = cell.myLittlePhoto.frame.size.height / 2
        
        return cell
    }
    
    
    func pairTableAndRealm() {
                guard let realm = try? Realm() else { return }
                getMyMessages = realm.objects(GetMyMessages.self)
        
                notificationToken = getMyMessages?.observe { [weak self] (changes: RealmCollectionChange) in
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
