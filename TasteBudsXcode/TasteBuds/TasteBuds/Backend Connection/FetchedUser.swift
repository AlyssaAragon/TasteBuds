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

    struct PartnerUser: Codable {
        let userid: Int
        let username: String
        let email: String
    }
}


