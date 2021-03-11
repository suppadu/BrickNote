//
//  AddCategoryViewController.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 11.03.2021.
//

import UIKit

class AddCategoryViewController: UIViewController {
    @IBOutlet weak var titleCategoryTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCategoryToCategoriesSegue"{
            let vc = segue.destination as! CategoriesTableViewController
            if titleCategoryTextField.text != nil && titleCategoryTextField.text != "" {
                vc.titleCategory = titleCategoryTextField.text
            } else{
                vc.titleCategory = "Категория"
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
