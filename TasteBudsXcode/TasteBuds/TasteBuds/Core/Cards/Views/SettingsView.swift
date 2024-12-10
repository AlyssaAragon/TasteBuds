import SwiftUI

struct SettingsView: View {
    @StateObject private var userFetcher = UserFetcher()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    Text("Settings")
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 19.5)
                .frame(width: 375, height: 56, alignment: .center)
                .background(Color.white)

                VStack(spacing: 8) {
                    if let user = userFetcher.currentUser {
                        Text("@\(user.username)")
                            .font(Font.custom("Inter", size: 16).weight(.black))
                            .kerning(0.08)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.12, green: 0.13, blue: 0.14))

                        if let dietPreference = user.dietPreference {
                            Text("Diet: \(dietPreference)")
                                .font(Font.custom("Inter", size: 12))
                                .kerning(0.12)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 0.44, green: 0.45, blue: 0.48))
                        }
                    } else {
                        Text("Loading...")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 200)

                Spacer(minLength: 22)

                //Settings List
                VStack(spacing: 0) {
                    NavigationLink(destination: PartnerSetupView()) {
                        settingsRow(title: "Partner")
                    }
                    Divider()
                    NavigationLink(destination: DietaryPreferencesView()) {
                        settingsRow(title: "Dietary Preferences") //after alyssa is done i need to change this so the skip button is gone  skip button only appears on first use of app
                    }
                    Divider()
                    settingsRow(title: "Notifications")
                    Divider()
                    settingsRow(title: "Privacy and Security")
                }
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 16)
                .padding(.bottom, 46)

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
            .onAppear {
                Task {
                    await userFetcher.fetchUser()
                }
            }
        }
    }

    @ViewBuilder
    private func settingsRow(title: String) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Text(title)
                .font(.body)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
