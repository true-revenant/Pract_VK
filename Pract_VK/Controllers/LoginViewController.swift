//
//  LoginViewController.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 03.03.2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ShowPassButton: UIButton!
    
    private var loadingPanel : UIView = UIView()
    private var authHandle: AuthStateDidChangeListenerHandle!
    
    
    @IBAction func SignUpButtonTapped(_ sender: UIButton) {
        // Создаем окошко Алерт
        let alert = UIAlertController(title: "Регистрация",
                                          message: "Регистрация",
                                          preferredStyle: .alert)
        // Добавляем на алерт 2 текстовых поля
        alert.addTextField { textEmail in
                textEmail.placeholder = "Введите email"
        }
        alert.addTextField { textPassword in
                textPassword.isSecureTextEntry = true
                textPassword.placeholder = "Введите пароль"
        }
        alert.addTextField { textPassword in
                textPassword.isSecureTextEntry = true
                textPassword.placeholder = "Повторите пароль"
        }
        // Добавляем на алерт кнопку Отмены
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        // Добавляем на алерт кнопку Сохранить
        let saveAction = UIAlertAction(title: "Создать", style: .default) { _ in
            
            // Проверка если поля для регистрации заполнены
                guard let emailField = alert.textFields?[0],
                    let passwordField = alert.textFields?[1],
                    let password = passwordField.text,
                    let email = emailField.text else { return }
            
            // Проверка на совпадение паролей
            if alert.textFields?[1].text != alert.textFields?[2].text {
                self.showErrorMessageBox(message: "Пароли не совпадают!")
                return
            }
            
            // Создаем пользователя в Firebase Auth
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    self?.showErrorMessageBox(message: error.localizedDescription)
                }
                else {
                    // Если создание прошло успешно, то регистрируемся под этой учеткой
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }
        // Добавляем кнопки на Алерт
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func loginButtonTaped(_ sender: UIButton) {
        // Проверка на заполнение логина и пароля
        guard let email = login.text, let password = password.text,
          email.count > 0, password.count > 0 else {
            self.showErrorMessageBox(message: "Логин и пароль не введены!")
            return
        }
        // Если все ок, то логинимся под этим пользователем
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error, user == nil {
              self?.showErrorMessageBox(message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func ShowPassButtonDown(_ sender: UIButton) {
        print("Show password!")
        password.isSecureTextEntry = false
    }
    
    @IBAction func ShowPassButtonUp(_ sender: UIButton) {
        print("Hide password!")
        password.isSecureTextEntry = true
    }
    
    // Вывод окна с ошибкой
    private func showErrorMessageBox(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func UnwindToLoginView(unwindSegue: UIStoryboardSegue) {
        
        do {
            // Разлогиниваемся в AuthFirebase
            try Auth.auth().signOut()
            //self.dismiss(animated: true, completion: nil)
            login.text = ""
            password.text = ""
        }
        catch (let error)
        {
            print("Ошибка при выходе из системы: \(error)")
        }
    }
    
    // MARK: - Методы цикла жизни View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad() called")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear(animated) called")
        
        keyboardSubscribe()
        authListenerSubscribe()
    }
    
    private func keyboardSubscribe() {
        // Подписываемся на нотификатор о появлении и исчезновении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardUnsubscribe() {
        // Отписываемся от нотификатора о появлении или исчезновении клавиатуры
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func authListenerSubscribe() {
        self.authHandle = Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "SegueFromLoginToMainBar", sender: nil)
                self.login.text = ""
                self.password.text = ""
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initLoadingPanel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear(animated) called")
        
        Auth.auth().removeStateDidChangeListener(authHandle)
        keyboardUnsubscribe()
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
        loadingPanel = UIView(frame: CGRect(x: password.frame.origin.x, y: password.frame.origin.y + 30, width: password.bounds.width, height: 30))
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
}
