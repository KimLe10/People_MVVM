//
//  NetworkManager.swift
//  People_MVVM
//
//  Created by Kim Le on 3/24/26.
//

import Foundation
import Combine

enum NetworkError: Error, LocalizedError {
    case invalidURL, noData, serverError
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL provided was invalid."
        case .noData: return "No data was received from the server."
        case .serverError: return "The server encountered an error."
        }
    }
}

protocol PeopleService {
    func fetchPeople() -> AnyPublisher<[Person], Error>
}

final class NetworkManager: PeopleService {
    func fetchPeople() -> AnyPublisher<[Person], Error> {
        guard let url = URL(string: "https://61e947967bc0550017bc61bf.mockapi.io/api/v1/people") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Person].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
