//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Arslan Abdullaev on 26.01.2022.
//

import UIKit

class TaskViewController: UITableViewController {
    // MARK: - Private Properties
    private let taskData = TaskData.shared
    private let cellID = "task"
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskData.fetchData()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods

    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 224/255,
            green: 47/255,
            blue: 47/255,
            alpha: 194/255
            )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
            )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showSaveAlert(with: "Новая задача", and: "Что хотите записать?")
    }
}

    // MARK: - UITableViewDataSource

extension TaskViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskData.tasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskData.tasksList[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Изменить") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            self.showEditAlert(with: "Изменить", and: "Что хотите изменить?", indexPath: indexPath)
            actionPerformed(true)
        }
        edit.backgroundColor = .orange
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = taskData.tasksList[indexPath.row]
        taskData.tasksList.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        taskData.persistentContainer.viewContext.delete(task)
        taskData.saveContext()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UIAllertControllers
    
    private func showSaveAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.taskData.saveTask(task, self.tableView)
        }
        
        alert.view.layer.backgroundColor = CGColor(red: 217/255, green: 137/255, blue: 137/255, alpha: 199/255)
        alert.view.layer.cornerRadius = 15
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "Новая задача"
        }
        present(alert, animated: true)
    }
    
    private func showEditAlert(with title: String, and message: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            self.taskData.editTask(task, indexPath)
            self.tableView.reloadData()
        }
        
        alert.view.layer.backgroundColor = CGColor(red: 247/255, green: 167/255, blue: 92/255, alpha: 199/255)
        alert.view.layer.cornerRadius = 15
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            let task = self.taskData.tasksList[indexPath.row]
            textField.text = task.name
        }
        present(alert, animated: true)
    }

}

