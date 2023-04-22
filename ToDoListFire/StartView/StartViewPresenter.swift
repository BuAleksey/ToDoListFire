//
//  StartViewPresenter.swift
//  ToDoListFire
//
//  Created by Buba on 22.04.2023.
//

import Foundation
import Firebase

protocol StartViewPresenterProtocol {
    init(view: StartViewControllerProtocol)
    func showWarning(_ text: String)
    func didChangeListener()
    func loginButtonTapped(login: String?, password: String?)
    func registerButtonTaped(login: String?, password: String?)
}

class StartViewPresenter: StartViewPresenterProtocol {
    private let view: StartViewControllerProtocol
    private var reference = Database.database().reference()
    
    required init(view: StartViewControllerProtocol) {
        self.view = view
    }
    
    func showWarning(_ text: String) {
        view.showWarningLabel(text)
    }
    
    func didChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.view.showTaskTableViewController()
            }
        }
    }
    
    func loginButtonTapped(login: String?, password: String?) {
        guard let email = login, let password = password, email != "", password != "" else {
            view.showWarningLabel("Info is incorrect")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error != nil {
                self?.view.showWarningLabel("Error occured")
                return
            }
            
            if user != nil {
                self?.view.showTaskTableViewController()
            }
            
            self?.view.showWarningLabel("No sush user")        }
    }
    
    func registerButtonTaped(login: String?, password: String?) {
        guard let email = login, let password = password, email != "", password != "" else {
            view.showWarningLabel("Info is incorrect")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            guard error == nil, user != nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            let userF = UserFire(user: user!.user)
            let userRef = self.reference.child("users").child(userF.uid)
            userRef.setValue(["email": userF.email])
        }
    }
}
