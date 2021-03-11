//
//  CategoriesTableViewController.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 09.02.2021.
//

import UIKit
import RealmSwift

class CategoriesTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    var titleCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.title
        } else {
            cell.textLabel?.text = "No category"
        }

        return cell
    }
    
    //MARK: - Переходы на другие View
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
        print("Unwind srabotal")
        let newCategory = Category()
        newCategory.title = titleCategory!
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
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
