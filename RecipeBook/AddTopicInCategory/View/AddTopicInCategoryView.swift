//
//  AddTopicInCategoryView.swift
//  RecipeBook
//
//  Created by AnhDuc on 12/05/2024.
//

import SwiftUI

struct AddTopicInCategoryView: View {
    @StateObject var viewModel: TopicInCategoryViewModel
    @Environment(\.presentationMode) private var presentationMode
    @State var isShowPicker: Bool = false
    @State var isLoading: Bool = false

    var action: Action = .add

    var body: some View {
        ZStack {
            NavigationBar {
                content
            }

            loadingIndicator
        }
    }

    var content: some View {
        ScrollView {
            title

            thumpnailImg
        }
        .scrollIndicators(.hidden, axes: .vertical)
        .padding(.horizontal, 10)
        .navigationTitle(
            action == .add
                ? "Thêm chủ đề" : viewModel.selectedTopic?.title ?? "Cập nhật chủ đề"
        )
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(image: $viewModel.image)
        }
        .alert(
            "Vui lòng điền đầy đủ thông tin cần thiết.",
            isPresented: $viewModel.isShow
        ) {
            Button("OK", role: .cancel) {
                isLoading = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(
                    action: {
                        switch action {
                        case .add:
                            withAnimation {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    viewModel.createTopic()
                                }
                            }
                        case .edit:
                            withAnimation {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    viewModel.updateTopic()
                                }
                            }
                        }
                    },
                    label: {
                        Text(action == .add ? "Lưu" : "Cập nhật")
                            .bold()
                    }
                )
            }
        }
        .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }

    @ViewBuilder
    var loadingIndicator: some View {
        if isLoading {
            Indicator()
        }
    }

    var title: some View {
        VStack(spacing: 0) {
            Text("Tiêu đề:")
                .padding(.top, 20)
                .padding(.bottom, 10)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(
                "Tiêu đề của công thức",
                text: $viewModel.title,
                axis: .vertical
            )
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10.0)
                    .strokeBorder(Color.gray, style: StrokeStyle(lineWidth: 0.5))
            )
        }
    }

    var thumpnailImg: some View {
        VStack(spacing: 0) {
            Text("Hình ảnh:")
                .padding(.top, 20)
                .padding(.bottom, 10)
                .font(.title3)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                withAnimation {
                    self.isShowPicker.toggle()
                }
            } label: {
                if let image = viewModel.image {
                    image
                        .resizable()
                        .frame(height: 200)
                        .cornerRadius(10)
                        .padding(.vertical, 10)
                } else {
                    Text("Thêm")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }

        }
    }
}

#Preview {
    AddTopicInCategoryView(viewModel: .init())
}
