//
//  PhotosService.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import Foundation

protocol PhotosServiceProtocol {
    func request(completion: @escaping (Result<[Photo], Error>) -> Void)
}

final class PhotosService: PhotosServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func request(completion: @escaping (Result<[Photo], Error>) -> Void) {
        self.networkClient.request(urlString: "https://jsonplaceholder.typicode.com/photos") { (result: Result<[Photo], Error>) in
            switch result {
            case let .success(photos):
                completion(.success(photos))
            case .failure:
                completion(.failure(CommonError.connection))
            }
        }
    }
}
