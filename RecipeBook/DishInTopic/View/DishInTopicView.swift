//
//  DishInTopicView.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import SwiftUI

struct DishInTopicView: View {
    @StateObject var viewModel: DishInTopicViewModel

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
            if viewModel.filterDish.isEmpty {
                Text("Không có món ăn nào.")
                    .foregroundColor(.gray)
                    .frame(maxHeight: .infinity)
            } else {
                dishList
            }
        }
        .scrollIndicators(.hidden, axes: .vertical)
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity)
        .navigationTitle(viewModel.selectedTopicInCategory?.title ?? "Món ăn")
        .searchable(text: $viewModel.searchKeyWord)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    let vm = DishInTopicViewModel()
                    vm.selectedTopicInCategory = viewModel.selectedTopicInCategory
                    return AddDishView(viewModel: vm, action: .add)
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
    }

    var dishList: some View {
        List {
            ForEach(viewModel.filterDish, id: \.id) { dish in
                if !dish.isInvalidated {
                    listItem(dish: dish)
                        .swipeActions {
                            Button("Xóa") {
                                DispatchQueue.main.async {
                                    viewModel.deleteDish(dish: dish)
                                }
                            }
                            .tint(.red)
                            NavigationLink(
                                destination:
                                    AddDishView(viewModel: viewModel, action: .edit)
                                    .onAppear {
                                        viewModel.selectedDish = dish
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

    func listItem(dish: DishInTopic) -> some View {
        ZStack {
            NavigationLink(destination: {
                return DishRecipeView(dish: dish)
            }) {

            }
            CategoryItemView(
                name: dish.name,
                image: dish.image.loadImage()
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
    DishInTopicView(viewModel: .init())
}
