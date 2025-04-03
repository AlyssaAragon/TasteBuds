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
        let calendar = Calendar.current
        return !calendar.isDateInToday(lastDate)
    }
    func updateLastPopupDate() {
        UserDefaults.standard.set(Date(), forKey: lastPopupKey)
    }
}
