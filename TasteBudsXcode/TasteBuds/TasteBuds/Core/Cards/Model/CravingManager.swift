//
//  CravingManager.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 3/14/25.
//

import Foundation

class CravingManager {
    static let shared = CravingManager()
    
    private func cravingPopupKey(for userID: Int) -> String {
        return "lastCravingPopupDate_\(userID)"
    }

    func allowCravingPopup(for userID: Int) -> Bool {
        let lastDate = UserDefaults.standard.object(forKey: cravingPopupKey(for: userID)) as? Date ?? Date.distantPast
        let now = Date()
        let hoursPassed = now.timeIntervalSince(lastDate) / 3600.0
        return hoursPassed >= 24
    }

    func updateLastPopupDate(for userID: Int) {
        UserDefaults.standard.set(Date(), forKey: cravingPopupKey(for: userID))
    }
}
