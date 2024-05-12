//
//  DishRecipeView.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import SwiftUI

struct DishRecipeView: View {
    @State var dish: DishInTopic

    var body: some View {
        NavigationBar {
            content
        }
    }

    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                title

                thumpnailImg

                ingredients

                instruction

                note
            }
        }
        .scrollIndicators(.hidden, axes: .vertical)
        .padding(.horizontal, 10)
        .navigationTitle(dish.name)
    }

    @ViewBuilder
    var title: some View {
        if !dish.title.isEmpty {
            Text(dish.title)
                .padding()
                .font(.title2)
                .multilineTextAlignment(.center)
                .bold()
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    var thumpnailImg: some View {
        dish.image.loadImage()
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
    }

    @ViewBuilder
    var ingredients: some View {
        if !dish.ingredient.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text("Nguyên liệu:")
                    .font(.title3)
                    .bold()
                    .padding(.top, 20)

                Text(dish.ingredient)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
            }
        }
    }

    @ViewBuilder
    var instruction: some View {
        if !dish.instruction.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text("Hướng dẫn:")
                    .font(.title3)
                    .bold()
                    .padding(.top, 20)

                Text(dish.instruction)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
            }
        }
    }

    @ViewBuilder
    var note: some View {
        if !dish.note.isEmpty {
            VStack(alignment: .leading, spacing: 0) {
                Text("Lưu ý:")
                    .font(.title3)
                    .bold()
                    .padding(.top, 20)

                Text(dish.note)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
            }
        }
    }
}

#Preview {
    DishRecipeView(dish: DishInTopic())
}
