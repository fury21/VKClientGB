//
//  NewPostController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 16.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit

class NewPostController: UIViewController {

    var coordinateNews: (Double, Double)?
    
    let vKService = VKService()
    
        @IBAction func cancelAddNGeo(unwindSegue: UIStoryboardSegue) {}
    
    
    @IBOutlet weak var postText: UITextField!
    
    @IBAction func postButton(_ sender: Any) {
        
//        print(coordinateNews.0, coordinateNews.1)
        vKService.newVkPost(message: postText.text!, coord: coordinateNews)
        
        //dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func addGeoToPost(segue: UIStoryboardSegue) {
//        //Проверяем идентификатор перехода, что бы убедится что это нужныий переход
//        if segue.identifier == "addGeoToPost" {
//            //получаем ссылку на контроллер с которого осуществлен переход
//            let postGeo = segue.source as! AddGeoController
//
//
//            print("ffff", a)
//
//
//            //                    vKService.joinAndLeaveAnyGroup(groupId: group.id, action: .joinGroup)
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
