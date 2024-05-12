//
//  DishInTopic.swift
//  RecipeBook
//
//  Created by AnhDuc on 12/05/2024.
//

import Foundation
import RealmSwift

class DishInTopic: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = UUID()
    @Persisted var name: String = ""
    @Persisted var title: String = ""
    @Persisted var image: Data
    @Persisted var ingredient: String = ""
    @Persisted var instruction: String = ""
    @Persisted var note: String = ""
    @Persisted var topicInCategoryId: UUID

    override init() {}

    init(
        id: UUID = UUID(),
        name: String,
        title: String,
        image: Data,
        ingredient: String,
        instruction: String,
        note: String,
        topicInCategoryId: UUID
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.image = image
        self.ingredient = ingredient
        self.instruction = instruction
        self.note = note
        self.topicInCategoryId = topicInCategoryId
    }
}
