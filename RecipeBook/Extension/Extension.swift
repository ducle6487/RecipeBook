//
//  Extension.swift
//  RecipeBook
//
//  Created by AnhDuc on 06/05/2024.
//

import UIKit
import SwiftUI
import RealmSwift

extension View {
    // This function changes our View to UIView, then calls another function
    // to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

        // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        window!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    // This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension Results {
    func toArray() -> [Element] {
        return compactMap {
            $0
        }
    }
}

private var cacheImages: [Data: Image] = [:]

extension Data {
    func loadImage() -> Image {
        if let image = cacheImages.first(where: { key, value in
            return key == self
        }) {
            return image.value
        }

        let image = Image(uiImage: UIImage(data: self)!)
        cacheImages[self] = image

        return image
    }
}

extension Image {
    func loadData() -> Data {
        if let data = cacheImages.first(where: { key, value in
            return value == self
        }) {
            return data.key
        }

        let data = self.asUIImage().jpegData(compressionQuality: 0.6) ?? Data()
        cacheImages[data] = self

        return data
    }
}
