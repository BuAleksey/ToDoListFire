//
//  TasksTableViewController.swift
//  ToDoListFire
//
//  Created by Buba on 25.03.2023.
//

import UIKit
import Firebase

class TasksTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let alertController = UIAlertController(title: "New", message: "task", preferredStyle: .alert)
        alertController.addTextField()
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alertController.textFields?.first?.text, task != "" else { return }
            //save task
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
}
