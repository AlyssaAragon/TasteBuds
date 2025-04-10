//
//  PrivacySecurityView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 4/10/25.
//

import SwiftUI

struct PrivacySecurityView: View {
    var body: some View {
        Text("At TasteBuds, protecting your personal information and ensuring a secure experience is our top priority. Here’s how we keep your data safe:")
        Text("🔐 Data Privacy")
        Text("Account Information: We collect only essential details (email, username, preferences) to personalize your experience.")
        Text("Partner Syncing: Recipe matches and shared meal plans are visible only between linked accounts.")
        Text("No Selling of Data: We do not sell, rent, or share your data with third parties.")
        Text("🛡️ Security Measures")
        Text("Encrypted Authentication: All logins use secure protocols and access tokens to protect your session.")
        Text("Secure Storage: User data is stored in a protected backend database with restricted access.")
        Text("Token Expiry: Expired sessions prompt automatic logout to prevent unauthorized access.")
        Text("⚙️ User Control")
        Text("Edit or Delete Account: You can update or delete your account at any time from the settings.")
        Text("Manage Permissions: Choose what you share with your partner and what stays private.")
    }
}

#Preview {
    PrivacySecurityView()
}
