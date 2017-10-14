//
//  MyGroupsController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 21.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import RealmSwift

class MyGroupsController: UITableViewController {
    
    let vKService = VKService()
    var getMyGroups = [GetMyGroups]()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGroupsFromRealm()
       
        vKService.loadVKAnyGroups(vKId: vKService.userVkId) { [weak self] in
            self?.loadGroupsFromRealm()
            self?.tableView?.reloadData()
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadGroupsFromRealm() {
        do {
            let realm = try Realm()
            let realmroups = realm.objects(GetMyGroups.self)
            self.getMyGroups = Array(realmroups)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getMyGroups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupsCell", for: indexPath) as! MyGroupsCell
        
        let groups = getMyGroups[indexPath.row]
        cell.myGroupLabel.text = groups.groupName
        
        cell.myGroupImage?.setImageFromURL(stringImageUrl: groups.groupPhoto50)
        
        cell.myGroupImage.layer.masksToBounds = true
        cell.myGroupImage.layer.cornerRadius = 25
        
//        cell.myGroupImage.layer.borderColor = UIColor.black.cgColor
//        cell.myGroupImage.layer.borderWidth = 0.5
        
        
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
                if !getMyGroups.contains(where: { $0.groupId == group.groupId } ) {
                    //добавляем город в список выбранных городов
                    
                    vKService.joinAndLeaveAnyGroup(groupId: group.groupId, action: .joinGroup)
                    getMyGroups.append(GetMyGroups(groupId: group.groupId, groupName: group.groupName, groupPhoto50: group.groupImg50))
                    
                    //обновляем таблицу
                    tableView.reloadData()
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
            
            vKService.joinAndLeaveAnyGroup(groupId: getMyGroups[indexPath.row].groupId, action: .leaveGroup)
            getMyGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
