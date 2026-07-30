//
//  Person.swift
//  People_MVVM
//
//  Created by Kim Le on 3/24/26.
//

import Foundation

struct Person: Decodable, Identifiable, Sendable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let avatar: String? 
    let jobTitle: String?
    let favouriteColor: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, email, avatar, favouriteColor, createdAt
        case jobTitle = "jobtitle"
    }
}
