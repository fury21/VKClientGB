////
////  AuthViewController.swift
////  1L_Бычковский А.В.
////
////  Created by Александр Б. on 13.09.17.
////  Copyright © 2017 Александр Б. All rights reserved.
////
//
//import UIKit
//
//class LoginFormController: UIViewController {
//    @IBOutlet weak var loginView: UITextField!
//    @IBOutlet weak var passwordView: UITextField!
//    @IBOutlet weak var scrollView: UIScrollView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        //жест нажатия
//        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
//        //присваиваем его UIScrollVIew
//        scrollView?.addGestureRecognizer(hideKeyboardGesture)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//
//        //Подписываемся на два уведомления, одно приходит при появляении клавиатуры
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        // Второе когда она пропадает
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    @objc func hideKeyboard() {
//        self.scrollView?.endEditing(true)
//    }
//
//    @IBAction func loginButtonPressed(_ sender: Any) {
//
//    }
//
//    @IBAction func logOut(unwindSegue: UIStoryboardSegue) {}
//
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        //Проверяем данные
//        let checkResult = checkUserData()
//
//        //если данные не верны покажем ошибку
//        if !checkResult {
//            showAlert(title: "Ошибка", message: "Не правильно введен логин или пароль. Повторите попытку.")
//        }
//
//        //вернем результат
//        return checkResult
//    }
//
//    func checkUserData() -> Bool {
//        let login = loginView.text!
//        let password = passwordView.text!
//
//        if login == "" && password == "" {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func showAlert(title: String, message: String) {
//        //Создаем контроллер
//        let alter = UIAlertController(title: title, message: message, preferredStyle: .alert)
//    //Создаем кнопку для UIAlertController
//    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//    //Добавляем кнопку на UIAlertController
//    alter.addAction(action)
//    //показываем UIAlertController
//    present(alter, animated: true, completion: nil)
//    }
//
//
//    /*
//     // MARK: - Navigation
//
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
//
//    //когда клавиатура появляется
//    @objc func keyboardWasShown(notification: Notification) {
//
//        //получем размер клавиатуры
//        let info = notification.userInfo! as NSDictionary
//        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
//        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
//
//        //Добавляем отсуп внизу UIScrollView равный размеру клавиатуры
//        self.scrollView?.contentInset = contentInsets
//        scrollView?.scrollIndicatorInsets = contentInsets
//    }
//
//    //когда клавиатура исчезает
//    @objc func keyboardWillBeHidden(notification: Notification) {
//        //устанавливаем отступ внизу UIScrollView равный 0
//        let contentInsets = UIEdgeInsets.zero
//        scrollView?.contentInset = contentInsets
//        scrollView?.scrollIndicatorInsets = contentInsets
//    }
//
//}

