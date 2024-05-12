//
//  CategoryItemView.swift
//  RecipeBook
//
//  Created by AnhDuc on 05/05/2024.
//

import SwiftUI

struct CategoryItemView: View {
    var name: String
    var image: Image

    var body: some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 210)
                .overlay {
                    Color.black.opacity(0.3)
                }
            Text(name)
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .cornerRadius(10)
    }
}

#Preview {
    CategoryItemView(name: "Đồ uống", image: Image("image"))
}
