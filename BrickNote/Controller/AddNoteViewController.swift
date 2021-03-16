//
//  DetailViewController.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 09.02.2021.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var titleNoteTextField: UITextField!
    @IBOutlet weak var textNoteTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textNoteTextView.layer.borderWidth = 0.5
        textNoteTextView.layer.borderColor = CGColor(gray: 0.5, alpha: 1.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNoteSegue" {
            let vc = segue.destination as! NotesTableViewController
            if titleNoteTextField.text != nil && titleNoteTextField.text != ""{
                vc.titleNote = titleNoteTextField.text
            } else {
                vc.titleNote = "Заметка"
            }
            vc.textNote = textNoteTextView.text
        }
    }
}
