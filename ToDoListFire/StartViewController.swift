//
//  ViewController.swift
//  ToDoListFire
//
//  Created by Buba on 12.03.2023.
//

import UIKit
import Firebase

class StartViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.text = "ToDoList"
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "User does not exist"
        label.textColor = .red
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gray
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 5
        button.layer.opacity = 0.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(loginButtonTaped), for: .touchUpInside)
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Register", for: .normal)
        button.tintColor = .gray
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(registerButtonTaped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9969663024, green: 0.9919849038, blue: 0.5153911114, alpha: 1)
        warningLabel.alpha = 0
        setupSubViews()
        hidenKeyboardWhenTapped()
        addOserver()
        
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                let viewController = NavigationController(rootViewController: TasksTableViewController())
                viewController.modalPresentationStyle = .fullScreen
                self?.present(viewController, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordTextField.text = ""
    }
    
    private func setupSubViews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(logoLabel)
        scrollView.addSubview(warningLabel)
        scrollView.addSubview(loginTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(registerButton)
        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 200),
            logoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            warningLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 20),
            warningLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            loginTextField.widthAnchor.constraint(equalToConstant: 300),
            loginTextField.topAnchor.constraint(equalTo: warningLabel.bottomAnchor, constant: 50),
            loginTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 10),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 100),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            registerButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func loginButtonTaped() {
        guard
            let email = loginTextField.text,
                let password = passwordTextField.text,
                email != "",
                password != ""
        else {
            showWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                self?.showWarningLabel(withText: "Error occured")
                return
            }
            
            if user != nil {
                let viewController = NavigationController(rootViewController: TasksTableViewController())
                viewController.modalPresentationStyle = .fullScreen
                self?.present(viewController, animated: true)
            }
            
            self?.showWarningLabel(withText: "No sush user")
        }
    }
    
    @objc private func registerButtonTaped() {
        guard
            let email = loginTextField.text,
                let password = passwordTextField.text,
                email != "",
                password != ""
        else {
            showWarningLabel(withText: "Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil {
                if user != nil {
                    
                } else {
                    print("user is not created")
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @objc private func keyBoardDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyBoardFrameSize = (
            userInfo[
                UIResponder.keyboardFrameEndUserInfoKey
            ] as! NSValue
        ).cgRectValue
        scrollView.contentSize = CGSize(
            width: view.bounds.width,
            height: view.bounds.height + keyBoardFrameSize.height
        )
        scrollView.scrollIndicatorInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyBoardFrameSize.height,
            right: 0
        )
    }
    
    @objc private func keyBoardDidHide() {
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    private func hidenKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = true
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func addOserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    private func showWarningLabel(withText text: String) {
        warningLabel.text = text
        
        UIView.animate(
            withDuration: 3,
            delay: 0,
            options: .curveEaseOut) { [unowned self] in
                self.warningLabel.alpha = 1
            } completion: { [unowned self] _ in
                self.warningLabel.alpha = 0
            }
    }
}

