//
//  FakeNetworkManager.swift
//  People_MVVMTests
//
//  Created by Kim Le on 3/24/26.
//

import Foundation
import Combine
@testable import People_MVVM


class FakeNetworkManager: PeopleService {
    var testPath:String = ""

    func fetchPeople() -> AnyPublisher<[Person], Error> {
       
        let bundle = Bundle(for: FakeNetworkManager.self)
        
//        print("--- DEBUG ---")
//        print("Searching for: \(testPath).json")
//        print("In Bundle: \(bundle.bundlePath)")
        
        guard let urlObj = bundle.url(forResource: testPath, withExtension: "json") else {
            print("FILE NOT FOUND: \(testPath).json")
            return Fail(error: URLError(.fileDoesNotExist))
                .eraseToAnyPublisher()
        }
        do {
            let data = try Data (contentsOf: urlObj)
            let decodeData = try JSONDecoder().decode([Person].self, from: data)
            print(" Successfully decoded \(decodeData.count) people.")
            return Just(decodeData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            print(" Decoding Failed: \(error)")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
}
