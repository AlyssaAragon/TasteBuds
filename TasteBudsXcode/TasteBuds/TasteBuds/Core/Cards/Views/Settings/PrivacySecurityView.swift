import SwiftUI

struct PrivacySecurityView: View {
    var body: some View {
        ZStack {
            Color.clear
                .customGradientBackground()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Privacy & Security")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    
                    Text("At TasteBuds, your privacy and security are our top priorities. We are committed to protecting your personal information and providing a safe and secure experience. Here's how we safeguard your data:")
                    
                    Divider()
                    
                    Text("Data Privacy")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• **Account Information**: We only collect essential information (such as your email, username, and dietary preferences) to personalize your TasteBuds experience.")
                        Text("• **Partner Syncing**: Recipe matches and shared meal plans are visible only to linked partner accounts. Your connections stay private and secure.")
                        Text("• **No Selling of Data**: We never sell, rent, or share your personal information with third parties. Your data belongs to you, and you alone.")
                    }
                    
                    Divider()
                    
                    Text("Security Measures")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• **Encrypted Authentication**: All logins and data exchanges are protected using secure encryption protocols and access tokens.")
                        Text("• **Secure Storage**: Your information is stored in a secured backend database with strict access controls.")
                        Text("• **Session Expiry**: Sessions automatically expire after a period of inactivity, requiring you to log in again to maintain account security.")
                    }
                    
                    Divider()
                    
                    Text("User Control")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• **Edit Account**: You have full control over your account settings, including updating your information or adding/removing your tastebud from your account at any time.")
                    }
                    
                    Divider()
                    
                    Text("Thank you for trusting TasteBuds. We're committed to protecting your information so you can focus on what matters most—cooking, connecting, and sharing meals you love.")
                        .padding(.top, 20)
                }
                .padding()
            }
        }
    }
}

#Preview {
    PrivacySecurityView()
}
