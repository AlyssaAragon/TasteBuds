//
//  FetchedUser.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/9/24.
//
import Foundation

struct FetchedUser: Identifiable, Decodable {
    let id: Int
    let username: String
    let dietPreference: String?

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case dietPreference = "diet_preference"
    }
}
