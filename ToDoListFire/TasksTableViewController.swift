//
//  TasksTableViewController.swift
//  ToDoListFire
//
//  Created by Buba on 25.03.2023.
//

import UIKit
import Firebase

class TasksTableViewController: UITableViewController {
    
    var user: UserFire!
    var reference: DatabaseReference!
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupNavigationBar()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        user = UserFire(user: currentUser)
        reference = Database.database().reference().child("users").child(user.uid).child("tasks")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = #colorLiteral(red: 0.9969663024, green: 0.9919849038, blue: 0.5153911114, alpha: 1)
        var content = cell.defaultContentConfiguration()
        content.text = "1"
        cell.contentConfiguration = content
        
        return cell
    }
    
    @objc private func addTapped() {
        let alertController = UIAlertController(
            title: "New",
            message: "task",
            preferredStyle: .alert
        )
        
        alertController.addTextField()
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let textFieldText = alertController.textFields?.first?.text, textFieldText != "" else { return }
            let task = Task(title: textFieldText, userId: (self?.user.uid)!)
            let taskReference = self?.reference.child(task.title.lowercased())
            taskReference?.setValue(task.convertToDictionary())
        }
        
        let canctlAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(saveAction)
        alertController.addAction(canctlAction)
        present(alertController, animated: true)
    }
    
    @objc private func signOutTapped() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true)
    }
    
    private func setupNavigationBar() {
        view.backgroundColor = #colorLiteral(red: 0.9969663024, green: 0.9919849038, blue: 0.5153911114, alpha: 1)
        
        title = "Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Sign out",
            style: .plain,
            target: self,
            action: #selector(signOutTapped))
    }
}
