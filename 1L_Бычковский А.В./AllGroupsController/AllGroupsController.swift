//
//  AllGroupsController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 20.09.17.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController, UISearchBarDelegate {
    
    
    let vKService = VKService()
    var searchMyGroup = [GetMyGroups]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        searchBar.returnKeyType = UIReturnKeyType.done // кнопка "найти" на клавиатуре.
        
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
        return searchMyGroup.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        
        cell.groupName.text = searchMyGroup[indexPath.row].groupName
        
        cell.groupImg.sd_setImage(with: URL(string: searchMyGroup[indexPath.row].groupPhoto50), placeholderImage: nil, options: [.highPriority, .refreshCached, .retryFailed])
        
        // округление фото
        cell.groupImg.layer.masksToBounds = true
        cell.groupImg.layer.cornerRadius = cell.groupImg.frame.size.height / 2
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchBar.text!.isEmpty else {
            searchMyGroup.removeAll()
            tableView.reloadData()
            return
        }
        
        
        vKService.searchVKAnyGroups(q: searchBar.text!.lowercased())  { [weak self] searchMyGroup in
            self?.searchMyGroup = searchMyGroup
            self?.tableView?.reloadData()
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
