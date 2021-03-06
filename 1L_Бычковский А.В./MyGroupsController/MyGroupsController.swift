//
//  MyGroupsController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 21.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseDatabase

class MyGroupsController: UITableViewController {
    
    let vKService = VKService()
    var getMyGroups: Results<GetMyGroups>?
    
    var notificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentOffset = CGPoint(x: 0, y: 44)

        pairTableAndRealm()
        
        vKService.loadVKAnyGroups(vKId: vKService.userVkId)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        getMyGroups = realm.objects(GetMyGroups.self)
        
        notificationToken = getMyGroups?.observe { [weak self] (changes: RealmCollectionChange) in
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
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getMyGroups?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        
        guard let groups = getMyGroups?[indexPath.row] else {
            cell.textLabel?.text = ""
            return cell
        }
        
        cell.myGroupLabel.text = groups.groupName
        
        cell.myGroupImage?.sd_setImage(with: URL(string: groups.groupPhoto50), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed])
        
        cell.myGroupImage.layer.masksToBounds = true
        cell.myGroupImage.layer.cornerRadius = cell.myGroupImage.frame.size.height / 2
        

        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        //Проверяем идентификатор перехода, что бы убедится что это нужныий переход
        if segue.identifier == "addGroup" {
            //получаем ссылку на контроллер с которого осуществлен переход
            let allGroupsController = segue.source as! AllGroupsController
            
            //получаем индекс выделенной ячейки
            if let indexPath = allGroupsController.tableView.indexPathForSelectedRow {
                //получаем город по индксу
                let group = allGroupsController.searchMyGroup[indexPath.row]
                
                //Проверяем что такого города нет в списке
                if !(getMyGroups?.contains(where: { $0.id == group.id } ))! {
                    //добавляем город в список выбранных городов
                    
                    vKService.joinAndLeaveAnyGroup(groupId: group.id, action: .joinGroup)
                    
                    Realm.addDataToRealm(objects: [group])
                }
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
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            
            vKService.joinAndLeaveAnyGroup(groupId: getMyGroups![indexPath.row].id, action: .leaveGroup)
            
            Realm.deleteDataFromRealm(objects: [getMyGroups![indexPath.row]])
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
