//
//  Note.swift
//  BrickNote
//
//  Created by Дмитрий Константинов on 10.03.2021.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var text: String = ""
}
