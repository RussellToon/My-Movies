//
//  RemoteImageView.swift
//  My Movies
//
//  Created by Russell Toon on 24/01/2021.
//

import SwiftUI

struct RemoteImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage(named: "MovieThumbPlaceHolder") ?? UIImage()

    init(imagePath: String, size: ImageService.ImageSize) {
        imageLoader = ImageLoader(imageSize: size, path: imagePath)
    }

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onReceive(imageLoader.didChange) { receivedImage in
                self.image = receivedImage
            }
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(imagePath: "/nTmYMM7divfQx6CrGUEnU0EbLEZ.jpg", size: .small)
    }
}
