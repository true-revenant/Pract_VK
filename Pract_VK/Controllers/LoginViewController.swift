//
//  LoginViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 03.03.2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var ShowPassButton: UIButton!
    
    private var loadingPanel : UIView = UIView()

    @IBAction func Button_Tapped(_ sender: UIButton) {
        
        self.loadingPanel.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            if self.shouldPerformSegue(withIdentifier: "SegueFromLoginToMainBar_old", sender: self) {
                self.performSegue(withIdentifier: "SegueFromLoginToMainBar_old", sender: self)
            }
            self.loadingPanel.alpha = 0
        })
    }
    
    @IBAction func ShowPassButtonDown(_ sender: UIButton) {
        print("Show password!")
        password.isSecureTextEntry = false
    }
    
    @IBAction func ShowPassButtonUp(_ sender: UIButton) {
        print("Hide password!")
        password.isSecureTextEntry = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SegueFromLoginToMainBar" {
            if login.text == "admin" && password.text == "123456" { return true }
            else {
                print("Неверные логин и пароль!")
                showErrorMessageBox()
                return false
            }
        }
        else { return false }
    }
    
    // Вывод окна с ошибкой
    private func showErrorMessageBox() {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин и пароль", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func UnwindToLoginView(unwindSegue: UIStoryboardSegue) {
        login.text = ""
        password.text = ""
    }
    
    // MARK: - Конструкторы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad() called")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear(animated) called")
        
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initLoadingPanel()
        initShowPassButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear(animated) called")
    
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        scrollView?.contentInset = .zero
    }
        
    private func initLoadingPanel() {
        loadingPanel = UIView(frame: CGRect(x: password.frame.origin.x, y: password.frame.origin.y + 100, width: password.bounds.width, height: 30))
        loadingPanel.backgroundColor = .clear
        loadingPanel.alpha = 0
        view.addSubview(loadingPanel)
        view.layoutSubviews()
        
        let dot_center = UIView(frame: CGRect(x: loadingPanel.bounds.midX - 10, y: loadingPanel.bounds.midY - 10, width: 20, height: 20))
        dot_center.layer.cornerRadius = 10
        dot_center.clipsToBounds = true
        dot_center.layer.opacity = 0
        dot_center.backgroundColor = .black
        
        let dot_left = UIView(frame: CGRect(x: loadingPanel.bounds.midX - 60, y: loadingPanel.bounds.midY - 10, width: 20, height: 20))
        dot_left.layer.cornerRadius = 10
        dot_left.clipsToBounds = true
        dot_left.layer.opacity = 0
        dot_left.backgroundColor = .black
        
        let dot_right = UIView(frame: CGRect(x: loadingPanel.bounds.midX + 40, y: loadingPanel.bounds.midY - 10, width: 20, height: 20))
        dot_right.layer.cornerRadius = 10
        dot_right.clipsToBounds = true
        dot_right.layer.opacity = 0
        dot_right.backgroundColor = .black
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            dot_left.layer.opacity = 1
        }, completion: { _ in })

        UIView.animate(withDuration: 1, delay: 0.3, options: [.autoreverse, .repeat], animations: {
            dot_center.layer.opacity = 1
        }, completion: { _ in })
        
        UIView.animate(withDuration: 1, delay: 0.6, options: [.autoreverse, .repeat], animations: {
            dot_right.layer.opacity = 1
        }, completion: { _ in })
        
        loadingPanel.addSubview(dot_center)
        loadingPanel.addSubview(dot_left)
        loadingPanel.addSubview(dot_right)
    }
    
    private func removeLoadingPanel() {
        loadingPanel.removeFromSuperview()
        loadingPanel = UIView()
    }
    
    private func initShowPassButton() {
        //ShowPassButton.setTitle("123", for: .normal)
        
//        ShowPassButton.setImage(UIImage(named: "arrowtriangle.forward.circle"), for: .normal)
//        ShowPassButton.setImage(UIImage(named: "arrowtriangle.right.circle.fill"), for: .selected)
    }
}
