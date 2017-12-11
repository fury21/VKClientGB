//
//  NewPostController.swift
//  1L_Бычковский А.В.
//
//  Created by Александр Б. on 16.11.2017.
//  Copyright © 2017 Александр Б. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewPostController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var postText: UITextField!
    @IBOutlet weak var postButtonOutlet: UIButton!
    
    
    var coordForPost: (Double, Double)?
    
    let vKService = VKService()
    var getMyPostToWall: GetMyPostToWall?
    
    var imageToPostFromLibrary: UIImage?
    
    @IBOutlet var postToolBar: UIToolbar!
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    @IBAction func cameraPost(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false

        self.present(image, animated: true) {
            //After it is complete
        }
    }
    
    
    func myImageUploadRequest(serverUrl: String) {
        let myUrl = NSURL(string: serverUrl)
        
        let request = NSMutableURLRequest(url:myUrl! as URL)
        request.httpMethod = "POST"
        
        let param = [
            "firstName"  : "Sergey",
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageToPostFromLibrary!, 1)
        
        if (imageData == nil)  { return }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        myActivityIndicator.startAnimating();
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
//            print("******* response = \(response)")
            
            // Print out reponse body
//            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //            print("****** response data = \(responseString!)")
            
            do {
                let data = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                let json = JSON(data!)
                
                
                self.vKService.saveWallPhotoToVkServer(photo: json["photo"].stringValue, server: json["server"].stringValue, hash: json["hash"].stringValue) { [weak self] completion in
                    
                    self?.vKService.newVkPost(message: (self?.postText.text!)!, geo: self?.coordForPost, att: completion)
                    self?.performSegue(withIdentifier: "doneNewPost", sender: self)

                }
                
                DispatchQueue.main.async {
                    self.myActivityIndicator.stopAnimating()
                    self.imageToPostFromLibrary = nil
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageToPostFromLibrary = image
            
            if imageToPostFromLibrary != nil || coordForPost != nil || !(postText.text?.isEmpty)! {
                postButtonOutlet.isEnabled = true
            } else {
                postButtonOutlet.isEnabled = false
            }
            
        } else {
            //Error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
    
    

    @IBAction func unwindFromMapKit(segue: UIStoryboardSegue) {
        let source = segue.source as! AddGeoController
        self.coordForPost = source.coordForPost
        
        if !(postText.text?.isEmpty)! || coordForPost != nil || imageToPostFromLibrary != nil {
            postButtonOutlet.isEnabled = true
        } else {
            postButtonOutlet.isEnabled = false
        }
    }
    
  
    @IBAction func postButton(_ sender: Any) {
        
        if imageToPostFromLibrary != nil { // если не выбрано фото для поста
        self.vKService.getWallUploadServer { [weak self] completion in
            self?.getMyPostToWall = completion
            self?.myImageUploadRequest(serverUrl: (self?.getMyPostToWall?.serverUpload_url)!)
        }
        } else {
            vKService.newVkPost(message: (postText.text!), geo: coordForPost, att: nil)
            performSegue(withIdentifier: "doneNewPost", sender: self)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        postText.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        postText.delegate = self
        
        if (postText.text?.isEmpty)! {
            postButtonOutlet.isEnabled = false
        }
        
        postText.inputAccessoryView = postToolBar
        
        postText.becomeFirstResponder()
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

// блокирует кнопку "готово" при посте новости, если текст пустой и гео или фото не заданы.
extension NewPostController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (range.location == 0 && range.length == 0) { // когда пишешь
            postButtonOutlet.isEnabled = true
        } else if (range.location == 0 && range.length == 1) && coordForPost == nil && imageToPostFromLibrary == nil { // когда стер последний символ
            postButtonOutlet.isEnabled = false
        }
        return true
    }
}





// для загрузки фото http://swiftdeveloperblog.com/image-upload-example/
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
