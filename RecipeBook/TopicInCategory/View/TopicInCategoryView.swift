//
//  TopicInCategoryView.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import SwiftUI

struct TopicInCategoryView: View {
    @StateObject var viewModel: TopicInCategoryViewModel

    var body: some View {
        NavigationBar(
            {
                content
                    .background(Color.black.opacity(0.1))
            }
        )
    }

    var content: some View {
        VStack(spacing: 0) {
            if viewModel.filterTopic.isEmpty {
                Text("Không có chủ đề nào.")
                    .foregroundColor(.gray)
                    .frame(maxHeight: .infinity)
            } else {
                topicList
            }
        }
        .scrollIndicators(.hidden, axes: .vertical)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .navigationTitle(viewModel.selectedCategory?.title ?? "Chủ đề")
        .searchable(text: $viewModel.searchKeyWord)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    let vm = TopicInCategoryViewModel()
                    vm.selectedCategory = viewModel.selectedCategory
                    return AddTopicInCategoryView(
                        viewModel: vm,
                        action: .add
                    )
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }

    var topicList: some View {
        List {
            ForEach(viewModel.filterTopic, id: \.id) { topic in
                if !topic.isInvalidated {
                    listItem(topic: topic)
                        .swipeActions {
                            Button("Xóa") {
                                DispatchQueue.main.async {
                                    viewModel.deleteTopic(topic: topic)
                                }
                            }
                            .tint(.red)
                            NavigationLink(
                                destination:
                                    AddTopicInCategoryView(
                                        viewModel: viewModel,
                                        action: .edit
                                    )
                                    .onAppear {
                                        viewModel.selectedTopic = topic
                                    }
                            ) {
                                Button("Chỉnh sửa") {}
                            }
                            .tint(.green)
                        }
                }
            }
        }
        .safeAreaInset(
            edge: .top,
            content: {
                EmptyView().frame(height: 0)
            }
        )
        .listStyle(.plain)
        .listRowSpacing(10)
    }

    func listItem(topic: TopicInCategory) -> some View {
        ZStack {
            NavigationLink(destination: {
                let vm = DishInTopicViewModel()
                vm.selectedTopicInCategory = topic
                return DishInTopicView(viewModel: vm)
            }) {

            }
            CategoryItemView(
                name: topic.title,
                image: topic.image.loadImage()
            )
        }
        .listRowBackground(
            Rectangle()
                .cornerRadius(10)
                .background(Color.clear)
        )
        .listRowInsets(EdgeInsets())
    }
}

#Preview {
    TopicInCategoryView(viewModel: .init())
}
