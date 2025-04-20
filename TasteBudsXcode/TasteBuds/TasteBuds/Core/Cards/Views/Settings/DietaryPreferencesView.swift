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
    @State private var showAlert: Bool = false
    @State private var isFirstUse: Bool = UserDefaults.standard.bool(forKey: "isFirstUse")
    @State private var selectedDiets: Set<Diet> = []

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Select your dietary preferences")) {
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
                        }
                    }
                }

                Section {
                    Button(action: savePreferences) {
                        HStack {
                            Spacer()
                            Text("Save Preferences")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Dietary Preferences")
            .toolbar {
                if isFirstUse {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink("Skip", destination: CardView())
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Preferences saved"),
                    message: Text("Your dietary preferences have been updated."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onAppear {
                if isFirstUse {
                    UserDefaults.standard.set(false, forKey: "isFirstUse")
                }
                loadSavedDiets()
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
                print("✅ Loaded user diets: \(selectedDiets)")
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
            } else {
                print("Failed to update diets:", error ?? "Unknown error")
            }
        }.resume()
    }
}
