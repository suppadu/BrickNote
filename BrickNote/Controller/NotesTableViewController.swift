//
//  DetailsTableViewController.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 09.02.2021.
//

import UIKit
import RealmSwift
import SwipeCellKit

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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! SwipeTableViewCell
        if let note = notes?[indexPath.row]{
            cell.textLabel?.text = note.title
        } else{
            cell.textLabel?.text = "No note"
        }
        cell.delegate = self
        return cell
    }
    
    //MARK: - Переход от AddNoteVC и сохранение данных в Realm
    
    @IBAction func unwindAddNote(unwindSegue: UIStoryboardSegue){
        print("Note is back")
        if let currentCategory = self.selectedCategory{
            do {
                try realm.write{
                    let newNote = Note()
                    newNote.title = titleNote ?? "Заметка"
                    newNote.text = textNote ?? ""
                    newNote.dateCreate = Date()
                    currentCategory.notes.append(newNote)
                }
            } catch {
                print("Note ne zapisalsya: \(error)")
            }
        }
        
        tableView.reloadData()
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "goToUpdateNote", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToUpdateNote"{
            let vc = segue.destination as! UpdateNoteViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.updateNote = notes?[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindUpdateNote(unwindSegue: UIStoryboardSegue){
        print("Update Note")
        if let indexPath = tableView.indexPathForSelectedRow{
            if let note = notes?[indexPath.row]{
                do {
                    try realm.write{
                        note.title = titleNote ?? "Заметка"
                        note.text = textNote ?? ""
                        note.dateCreate = Date()
                    }
                } catch {
                    print("Note ne zapisalsya: \(error)")
                }
            }
        }
        tableView.reloadData()
    }
    
    
    
    
    //MARK: - Загрузка Notes из Realm
    
    func load(){
        notes = selectedCategory?.notes.sorted(byKeyPath: "dateCreate", ascending: false)
        tableView.reloadData()
    }
}

    //MARK: - Swipe delegate method

extension NotesTableViewController: SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
            if let note = self.notes?[indexPath.row]{
                do {
                    try self.realm.write{
                        self.realm.delete(note)
                    }
                } catch  {
                    print(error)
                }
            }
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

