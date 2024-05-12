//
//  Category.swift
//  RecipeBook
//
//  Created by AnhDuc on 05/05/2024.
//

import Foundation
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var image: Data = Data()
    @Persisted var title: String = ""

    override init() {}

    init(id: UUID = UUID(), image: Data, title: String) {
        self.id = id
        self.image = image
        self.title = title
    }
}
