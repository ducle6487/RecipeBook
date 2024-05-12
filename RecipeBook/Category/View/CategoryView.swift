//
//  CategoryView.swift
//  RecipeBook
//
//  Created by AnhDuc on 05/05/2024.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var viewModel: CategoryViewModel
    @State var showAddCategoryView: Bool = false
    @State var showTopicInCategoryView: Bool = false

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
            if viewModel.filterCategory.isEmpty {
                Text("Không có danh mục nào.")
                    .foregroundColor(.gray)
                    .frame(maxHeight: .infinity)
            } else {
                categoryList
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .scrollIndicators(.hidden, axes: .vertical)
        .navigationTitle("Danh mục")
        .searchable(text: $viewModel.searchKeyWord)
        .navigationDestination(
            isPresented: $showAddCategoryView
        ) {
            return AddCategoryView(viewModel: viewModel, action: .edit)
        }
        .navigationDestination(
            isPresented: $showTopicInCategoryView
        ) {
            let vm = TopicInCategoryViewModel()
            vm.selectedCategory = viewModel.selectedCategory
            return TopicInCategoryView(viewModel: vm)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: AddCategoryView(
                        viewModel: .init(),
                        action: .add
                    )
                ) {
                    Image(systemName: "plus.circle")
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    var categoryList: some View {
        List {
            ForEach(viewModel.filterCategory, id: \.id) { category in
                if !category.isInvalidated {
                    listItem(category: category)
                        .swipeActions {
                            Button("Xóa") {
                                DispatchQueue.main.async {
                                    viewModel.deleteCategory(category: category)
                                }
                            }
                            .tint(.red)
                            Button(
                                action: {
                                    viewModel.selectedCategory = category
                                    showAddCategoryView.toggle()
                                },
                                label: {
                                    Text("Chỉnh sửa")
                                }
                            )
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

    func listItem(category: Category) -> some View {
        ZStack {
            CategoryItemView(
                name: category.title,
                image: category.image.loadImage()
            )
            .onTapGesture {
                viewModel.selectedCategory = category
                showTopicInCategoryView = true
            }
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
    CategoryView(viewModel: .init())
}
