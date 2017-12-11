//
//  FireBaseLoginController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 27.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import FirebaseAuth


class FireBaseLoginController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func enterButton(_ sender: Any) {
        checkUserData { [weak self] checkResult in
            if checkResult {
                self?.label.text = "Success login"
            } else {
                self?.label.text = "Wrong login!!!"
            }
        }
    }
    
    
    func checkUserData(completion: @escaping (Bool) -> Void) {
        let userLogin = login.text!
        let UserPassword = password.text!
        
        Auth.auth().signIn(withEmail: userLogin, password: UserPassword) { (user, error) in
            completion(user != nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login.text = "test@test.com"
        password.text = "123456"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
