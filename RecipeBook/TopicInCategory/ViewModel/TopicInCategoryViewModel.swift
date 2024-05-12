//
//  TopicInCategoryViewModel.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import SwiftUI
import RealmSwift
import Combine

class TopicInCategoryViewModel: ObservableObject {
    var selectedCategory: Category? {
        didSet {
            if let selectedCategory, !selectedCategory.isInvalidated {
                topic = realm.objects(TopicInCategory.self)
                    .filter("categoryId = %@", selectedCategory.id)
                updateFilteredResults()
            }
        }
    }
    private var topic: Results<TopicInCategory>
    private var notificationToken: NotificationToken?
    private var realm: Realm
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()

    @Published var filterTopic: [TopicInCategory] = []
    @Published var searchKeyWord: String = "" {
        didSet {
            updateFilteredResults()
        }
    }

    var selectedTopic: TopicInCategory? {
        didSet {
            if let selectedTopic, !selectedTopic.isInvalidated {
                title = selectedTopic.title
                image = selectedTopic.image.loadImage()
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
        topic = realm.objects(TopicInCategory.self)
            .filter("categoryId = %@", selectedCategory?.id ?? UUID())

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
            filterTopic = topic.toArray()
        } else {
            filterTopic = topic.filter { topic in
                // Check if the category is still valid before accessing its properties
                guard !topic.isInvalidated else { return false }
                return topic.title.lowercased().contains(searchKeyWord.lowercased())
            }
        }
    }

    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    func createTopic() {
        if validateContent(), let imageData = image?.loadData(), let selectedCategory {
            Task { @MainActor in
                try realm.write {
                    realm.create(
                        TopicInCategory.self,
                        value: TopicInCategory(
                            title: title,
                            image: imageData,
                            categoryId: selectedCategory.id
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

    func updateTopic() {
        if validateContent(), let selectedTopic,
            let topic = realm.object(ofType: TopicInCategory.self, forPrimaryKey: selectedTopic.id),
            let image
        {
            Task { @MainActor in
                try realm.write {
                    topic.image = image.loadData()
                    topic.title = title
                }
            }

            DispatchQueue.main.async {
                self.shouldDismissView = true
            }
        } else {
            isShow = true
        }
    }

    func deleteTopic(topic: TopicInCategory) {
        Task { @MainActor in
            let dishes = realm.objects(DishInTopic.self)
                .filter("topicInCategoryId = %@", topic.id)
            
            try realm.write {
                realm.delete(dishes)
                realm.delete(topic)
            }
        }
    }

    func validateContent() -> Bool {
        return !title.isEmpty && image != nil
    }
}
