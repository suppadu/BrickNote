//
//  CategoriesTableViewController.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 09.02.2021.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoriesTableViewController: UITableViewController{
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var titleCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
        load()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CustomTableViewCell
        if let category = categories?[indexPath.row]{
            cell.title.text = category.title
        } else {
            cell.title.text = "No category"
        }
        cell.delegate = self
        return cell
    }
    
    //MARK: - Переходы на другие View
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
        print("Unwind srabotal")
        let newCategory = Category()
        newCategory.title = titleCategory!
        newCategory.dateCreate = Date()
//        print(newCategory.dateCreate)
        do {
            try realm.write{
                realm.add(newCategory)
            }
        } catch {
            print("Category dont add in realm: \(error)")
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNote"{
            let vc = segue.destination as! NotesTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.selectedCategory = categories?[indexPath.row]
        }
        }
    }
    
    //MARK: - Чтение из Realm
    
    func load() {
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateCreate", ascending: false)
        tableView.reloadData()
    }
}

    //MARK: - Swipe delegate method

extension CategoriesTableViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
                if let category = self.categories?[indexPath.row]{
                    do {
                        try self.realm.write{
                            self.realm.delete(category.notes)
                            self.realm.delete(category)
                        }
                    } catch  {
                        print(error)
                    }
                }
//                tableView.reloadData()
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")

            return [deleteAction]

    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
