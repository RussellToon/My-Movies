//
//  ImageService.swift
//  My Movies
//
//  Created by Russell Toon on 23/01/2021.
//

import UIKit
import Combine


class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<UIImage, Never>()
    var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }
    private let imageService = ImageService()

    init(imageSize: ImageService.ImageSize = .small, path: String) {
        imageService.fetch(imageSize: imageSize, path: path) { result in
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                print("Failed to get image \(path) with error: \(error)")
                // self.image = failed placeholder
            }
        }
    }
}


typealias ImageServiceCompletion = (Result<UIImage, ImageService.Failure>) -> Void


struct ImageService {

    // Example: https://image.tmdb.org/t/p/w92/nTmYMM7divfQx6CrGUEnU0EbLEZ.jpg

    let endpointString = "https://image.tmdb.org/t/p"

    func fetch(imageSize: ImageSize, path: String, completion: @escaping ImageServiceCompletion) {
        guard let url = urlForImage(imageSize: imageSize, path: path) else {
            completion(.failure(.formingRequestUrl))
            return
        }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(.success(image))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        let responseAsString = String(decoding: data, as: UTF8.self)
                        completion(.failure(.creatingImageFromResponse(response: responseAsString)))
                    }
                }
            }
            else {
                completion(.failure(.noResponseData))
            }
        }
    }

    private func urlForImage(imageSize: ImageSize, path: String) -> URL? {
        //guard let path = path else { return nil }
        let urlString = endpointString + "/" + imageSize.rawValue + path
        return URL(string: urlString)
    }


    enum ImageSize: String {
        case small = "w92"
        case medium = "w185"
        case large = "w500"
    }


    enum Failure: Error {
        case formingRequestUrl
        case noResponseData
        case creatingImageFromResponse(response: String)
    }
}

