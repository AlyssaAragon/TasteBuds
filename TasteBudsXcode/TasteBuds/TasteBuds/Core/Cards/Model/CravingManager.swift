//
//  CravingManager.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 3/14/25.
//
import Foundation

class CravingManager {
    static let shared = CravingManager()
    private let lastPopupKey = "lastCravingPopupDate"

    func allowCravingPopup() -> Bool {
        let lastDate = UserDefaults.standard.object(forKey: lastPopupKey) as? Date ?? Date.distantPast
        let now = Date()
        let hoursPassed = now.timeIntervalSince(lastDate) / 3600.0
        return hoursPassed >= 24
    }

    func updateLastPopupDate() {
        UserDefaults.standard.set(Date(), forKey: lastPopupKey)
    }
}
