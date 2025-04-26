import SwiftUI

enum Diet: String, CaseIterable, Identifiable {
    case vegan, vegetarian, pescatarian
    case glutenFree = "gluten-free"
    case dairyFree = "dairy-free"
    case nutFree = "nut-free"
    case eggFree = "egg-free"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .vegan: return "Vegan"
        case .vegetarian: return "Vegetarian"
        case .pescatarian: return "Pescatarian"
        case .glutenFree: return "Gluten-Free"
        case .dairyFree: return "Dairy-Free"
        case .nutFree: return "Nut-Free"
        case .eggFree: return "Egg-Free"
        }
    }
}



struct DietaryPreferencesView: View {
    @EnvironmentObject var navigationState: NavigationState
    @Environment(\.dismiss) private var dismiss

    @AppStorage("isNewUser") private var isNewUser = false
    @State private var selectedDiets: Set<Diet> = []
    @State private var showAlert = false
    @State private var navigateToMainTab = false

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Select your dietary preferences")
                    .font(.largeTitle.bold())
                    .padding(.top)

                Text("Customize the recipes suggested to you by setting the diets you follow.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)

                List {
                    Section {
                        ForEach(Diet.allCases) { diet in
                            Toggle(isOn: Binding(
                                get: { selectedDiets.contains(diet) },
                                set: { isOn in
                                    if isOn {
                                        selectedDiets.insert(diet)
                                    } else {
                                        selectedDiets.remove(diet)
                                    }
                                }
                            )) {
                                Text(diet.label)
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    Section {
                        Button(action: savePreferences) {
                            HStack {
                                Spacer()
                                Text("Save Preferences")
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                NavigationLink(
                    destination: MainTabView()
                        .environmentObject(navigationState)
                        .environmentObject(UserFetcher())
                        .environmentObject(FavoritesManager())
                        .environmentObject(CalendarManager())
                        .environmentObject(ThemeManager()),
                    isActive: $navigateToMainTab
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        if let _ = navigationState.previousView {
                            navigationState.goBack()
                        } else {
                            dismiss()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                            Text("Back")
                                .font(.headline)
                        }
                        .foregroundColor(.black)
                    }
                }

                if isNewUser {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Skip") {
                            navigateToMainTab = true
                            isNewUser = false
                        }
                        .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                loadSavedDiets()
            }

            if showAlert {
                VStack(spacing: 16) {
                    Text("Preferences Saved")
                        .font(.title2.bold())
                        .foregroundColor(.black)

                    Text("Your dietary preferences have been updated.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                    Button(action: {
                        showAlert = false
                        navigateToMainTab = true
                        isNewUser = false
                    }) {
                        Text("OK")
                            .bold()
                            .frame(width: 100, height: 44)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
            }
        }
    }

    private func loadSavedDiets() {
        guard let url = URL(string: "https://tastebuds.unr.dev/api/user_profile/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        if let token = AuthService.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let dietArray = json["diets"] as? [[String: Any]] else {
                print("Failed to load diets")
                return
            }

            let dietStrings = dietArray.compactMap { $0["dietname"] as? String }

            DispatchQueue.main.async {
                selectedDiets = Set(dietStrings.compactMap { Diet(rawValue: $0) })
                print("Loaded user diets: \(selectedDiets)")
            }
        }.resume()
    }

    private func savePreferences() {
        let dietStrings = selectedDiets.map { $0.rawValue }

        guard let url = URL(string: "https://tastebuds.unr.dev/api/user_diets/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = AuthService.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let body = ["diets": dietStrings]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 200 {
                DispatchQueue.main.async {
                    showAlert = true
                }
            }
            else {
                print("Failed to update diets:", error ?? "Unknown error")
            }
        }.resume()
    }
}

#Preview {
    DietaryPreferencesView()
        .environmentObject(NavigationState())
}
