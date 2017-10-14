//
//  Settings.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 14.10.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class Settings: UITableViewController  {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutVK" {
            let logout = WebViewController()
            logout.logoutVK()
        }
    }
}
