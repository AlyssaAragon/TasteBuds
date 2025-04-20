//
//  FetchedUser.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/9/24.
//
import Foundation

struct FetchedUser: Codable {
    let userid: Int
    let username: String
    let email: String
    let firstlastname: String
    let partner: PartnerUser?
    let diets: [DietEntry]?

    
    struct DietEntry: Codable {
            let id: Int
            let dietname: String
        }
    
    struct PartnerUser: Codable {
        let userid: Int
        let username: String
        let email: String
    }
}


