//
//  Categories.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 10.03.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    let notes = List<Note>()
}
