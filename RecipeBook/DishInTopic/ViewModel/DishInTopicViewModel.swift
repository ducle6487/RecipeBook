//
//  DishInTopicViewModel.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import Foundation
import RealmSwift
import Combine
import SwiftUI

class DishInTopicViewModel: ObservableObject {
    private var dish: Results<DishInTopic>
    private var notificationToken: NotificationToken?
    private var realm: Realm
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()

    @Published var filterDish: [DishInTopic] = []
    @Published var searchKeyWord: String = "" {
        didSet {
            updateFilteredResults()
        }
    }

    var selectedTopicInCategory: TopicInCategory? {
        didSet {
            if let selectedTopicInCategory, !selectedTopicInCategory.isInvalidated {
                dish = realm.objects(DishInTopic.self)
                    .filter("topicInCategoryId = %@", selectedTopicInCategory.id)
                updateFilteredResults()
            }
        }
    }

    var selectedDish: DishInTopic? {
        didSet {
            if let selectedDish, !selectedDish.isInvalidated {
                name = selectedDish.name
                title = selectedDish.title
                image = selectedDish.image.loadImage()
                ingredient = selectedDish.ingredient
                instruction = selectedDish.instruction
                note = selectedDish.note
            }
        }
    }

    @Published var isShow = false
    @Published var name: String = ""
    @Published var title: String = ""
    @Published var image: Image?
    @Published var ingredient: String = ""
    @Published var instruction: String = ""
    @Published var note: String = ""

    init() {
        // Initialize Realm
        realm = try! Realm()

        // Fetch all objects initially
        dish = realm.objects(DishInTopic.self)
            .filter("topicInCategoryId = %@", selectedTopicInCategory?.id ?? UUID())

        // Apply initial filter
        updateFilteredResults()

        // Observe Realm changes
        notificationToken = realm.observe { [weak self] _, _ in
            self?.updateFilteredResults()
        }
    }

    deinit {
        if let token = notificationToken {
            token.invalidate()
        }
    }

    private func updateFilteredResults() {
        // Reapply filter on all objects
        if searchKeyWord.isEmpty {
            filterDish = dish.toArray()
        } else {
            filterDish = dish.filter { dish in
                // Check if the category is still valid before accessing its properties
                guard !dish.isInvalidated else { return false }
                return dish.title.lowercased().contains(searchKeyWord.lowercased())
            }
        }
    }

    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    func createDish() {
        if validateContent(), let imageData = image?.loadData(), let selectedTopicInCategory {
            Task { @MainActor in
                try realm.write {
                    realm.create(
                        DishInTopic.self,
                        value: DishInTopic(
                            name: name,
                            title: title,
                            image: imageData,
                            ingredient: ingredient,
                            instruction: instruction,
                            note: note,
                            topicInCategoryId: selectedTopicInCategory.id
                        ),
                        update: .all
                    )
                }
            }

            DispatchQueue.main.async {
                self.shouldDismissView = true
            }
        } else {
            isShow = true
        }
    }

    func updateDish() {
        if validateContent(), let selectedDish,
            let dish = realm.object(ofType: DishInTopic.self, forPrimaryKey: selectedDish.id),
            let image
        {
            Task { @MainActor in
                try realm.write {
                    dish.name = name
                    dish.image = image.loadData()
                    dish.title = title
                    dish.ingredient = ingredient
                    dish.instruction = instruction
                    dish.note = note
                }
            }

            DispatchQueue.main.async {
                self.shouldDismissView = true
            }
        } else {
            isShow = true
        }
    }

    func deleteDish(dish: DishInTopic) {
        Task { @MainActor in
            try realm.write {
                realm.delete(dish)
            }
        }
    }

    func validateContent() -> Bool {
        return !name.isEmpty && !title.isEmpty && image != nil && !ingredient.isEmpty
            && !instruction.isEmpty
    }
}
