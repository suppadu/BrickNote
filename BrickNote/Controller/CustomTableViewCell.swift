//
//  CustomTableViewCell.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 15.03.2021.
//

import UIKit
import SwipeCellKit

class CustomTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var inView: UIView!
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
