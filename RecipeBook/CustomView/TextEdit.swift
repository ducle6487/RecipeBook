//
//  TextEdit.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import SwiftUI

struct TextEdit: View {
    @Binding var text: String
    var placeHolder: String?

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                VStack {
                    Text(placeHolder ?? "")
                        .padding(.top, 10)
                        .padding(.leading, 2)
                    Spacer()
                }
            }

            VStack {
                TextEditor(text: $text)
                    .opacity(text.isEmpty ? 0.85 : 1)
                Spacer()
            }
        }
    }
}
