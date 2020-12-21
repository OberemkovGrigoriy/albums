//
//  AlbumService.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import Foundation

protocol AlbumServiceProtocol {
    func request(completion: @escaping (Result<[Album], Error>) -> Void)
}

final class AlbumService: AlbumServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func request(completion: @escaping (Result<[Album], Error>) -> Void) {
        self.networkClient.request(urlString: "https://jsonplaceholder.typicode.com/albums") { (result: Result<[Album], Error>) in
            switch result {
            case let .success(albums):
                completion(.success(albums))
            case .failure:
                completion(.failure(CommonError.connection))
            }
        }
    }
}
