//
//  NetworkClient.swift
//  Albums
//
//  Created by Gregory Oberemkov on 20.12.2020.
//

import Foundation
import Alamofire

protocol NetworkClientProtocol {
    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkClient: NetworkClientProtocol {
    enum NetworkError: Error {
        case urlIsIncorrect
        case connection
    }

    func request<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        let request = AF.request(urlString)
        if request.error?.isCreateURLRequestError != nil {
            completion(.failure(NetworkError.connection))
        }
        request.responseDecodable(of: T.self) { response in
            guard let value = response.value else {
                completion(.failure(NetworkError.connection))
                return
            }
            completion(.success(value))
        }
    }
}
