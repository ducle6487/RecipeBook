//
//  TopicInCategory.swift
//  RecipeBook
//
//  Created by AnhDuc on 12/05/2024.
//

import Foundation
import RealmSwift

class TopicInCategory: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var title: String
    @Persisted var image: Data
    @Persisted var categoryId: UUID

    init(id: UUID = UUID(), title: String, image: Data, categoryId: UUID) {
        self.id = id
        self.title = title
        self.image = image
        self.categoryId = categoryId
    }

    override init() {}
}
