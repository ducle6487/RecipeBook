//
//  CategoryViewModel.swift
//  RecipeBook
//
//  Created by AnhDuc on 05/05/2024.
//

import Foundation
import RealmSwift
import SwiftUI
import Combine

class CategoryViewModel: ObservableObject {
    private var category: Results<Category>
    private var notificationToken: NotificationToken?
    private var realm: Realm
    @Published var filterCategory: [Category] = []
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    @Published var searchKeyWord: String = "" {
        didSet {
            updateFilteredResults()
        }
    }

    var selectedCategory: Category? {
        didSet {
            if let selectedCategory, !selectedCategory.isInvalidated {
                title = selectedCategory.title
                image = selectedCategory.image.loadImage()
            }
        }
    }

    @Published var isShow = false
    @Published var title: String = ""
    @Published var image: Image?

    init() {
        // Initialize Realm
        realm = try! Realm()

        // Fetch all objects initially
        category = realm.objects(Category.self)

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
            filterCategory = category.toArray()
        } else {
            filterCategory = category.filter { category in
                // Check if the category is still valid before accessing its properties
                guard !category.isInvalidated else { return false }
                return category.title.lowercased().contains(searchKeyWord.lowercased())
            }
        }
    }

    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    func createCategory() {
        if validateContent(), let imageData = image?.loadData() {
            Task.detached { @MainActor [self] in
                try realm.write {
                    realm.create(
                        Category.self,
                        value: Category(
                            image: imageData,
                            title: title
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

    func updateCategory() {
        if validateContent(), let selectedCategory,
            let category = realm.object(
                ofType: Category.self,
                forPrimaryKey: selectedCategory.id
            ), let image
        {
            Task { @MainActor in
                try realm.write {
                    category.image = image.loadData()
                    category.title = title
                }
            }

            DispatchQueue.main.async {
                self.shouldDismissView = true
            }
        } else {
            isShow = true
        }
    }

    func deleteCategory(category: Category) {
        // Create a background task to perform Realm write operations
        Task { @MainActor in
            do {
                // Perform write transactions within a single write block
                try realm.write {
                    // Fetch topics related to the category
                    let topics = realm.objects(TopicInCategory.self)
                        .filter("categoryId = %@", category.id)

                    // Delete dishes related to each topic
                    for topic in topics {
                        let dishes = realm.objects(DishInTopic.self)
                            .filter("topicInCategoryId = %@", topic.id)
                        realm.delete(dishes)
                    }

                    // Delete topics
                    realm.delete(topics)

//                    // Delete the category
                    realm.delete(category)
                }
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }

    func validateContent() -> Bool {
        return !title.isEmpty && image != nil
    }
}
