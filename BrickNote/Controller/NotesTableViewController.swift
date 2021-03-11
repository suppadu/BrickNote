//
//  DetailsTableViewController.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 09.02.2021.
//

import UIKit
import RealmSwift

class NotesTableViewController: UITableViewController {
    
    var titleNote: String?
    var textNote: String?
    let realm = try! Realm()
    var notes: Results<Note>?
    var selectedCategory: Category? {
        didSet{
            load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = selectedCategory?.title
        print(realm.configuration.fileURL!)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        if let note = notes?[indexPath.row]{
            cell.textLabel?.text = note.title
        } else{
            cell.textLabel?.text = "No note"
        }
        return cell
    }
    
    //MARK: - Переход от NoteVC и сохранение данных в Realm
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
        print("Note is back")
        if let currentCategory = self.selectedCategory{
            do {
                try realm.write{
                    let newNote = Note()
                    newNote.title = titleNote ?? "Заметка"
                    newNote.text = textNote ?? ""
                    currentCategory.notes.append(newNote)
                }
            } catch {
                print("Note ne zapisalsya: \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
    
    
    
    //MARK: - Загрузка Notes из Realm
    
    func load(){
        notes = selectedCategory?.notes.sorted(byKeyPath: "title", ascending: true)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
