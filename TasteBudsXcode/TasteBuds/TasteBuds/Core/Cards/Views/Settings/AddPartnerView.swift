import SwiftUI

struct AddPartnerView: View {
    @EnvironmentObject var navigationState: NavigationState
    @StateObject private var userFetcher = UserFetcher()
    @State private var currentPartnerName: String? = nil
    @State private var incomingRequest: [String: Any]? = nil
    @State private var isLoading = true
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        ZStack {
            Color.clear.customGradientBackground()

            if isLoading {
                ProgressView("Loading partner info...")
            } else {
                VStack(spacing: 30) {
                    Spacer()

                    Image("connectPartner")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 350)
                        .clipped()

                    Text("Connect with your Taste Bud")
                        .font(.title)
                        .lineLimit(3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)

                    if let partner = currentPartnerName {
                        Text("Your partner is \(partner)")
                            .font(.headline)
                            .foregroundColor(.black)
                        Button("Remove Partner") {
                            removePartner()
                        }
                        .padding(.top, 10)
                        .foregroundColor(.red)

                    } else if let request = incomingRequest,
                              let fromUser = request["from_user"] as? [String: Any],
                              let username = fromUser["username"] as? String {
                        VStack(spacing: 12) {
                            Text("\(username) sent you a partner request")
                                .font(.headline)

                            HStack(spacing: 20) {
                                Button("Accept") {
                                    respondToRequest(action: "accept")
                                }
                                .padding()
                                .background(Color.green.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)

                                Button("Decline") {
                                    respondToRequest(action: "decline")
                                }
                                .padding()
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            }
                        }
                    } else {
                        NavigationLink(destination: PartnerSetupView(isNewUser: true).environmentObject(navigationState)) {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 314, height: 70)
                                .background(Color.white)
                                .cornerRadius(30)
                        }
                        .padding(.bottom, 40)
                    }

                    Spacer(minLength: 20)
                }
                .frame(width: 414, height: 896)
            }
        }
        .onAppear {
            Task {
                await fetchPartnerInfo()
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private func fetchPartnerInfo() async {
        isLoading = true
        await userFetcher.fetchUser()

        if let partner = userFetcher.currentUser?.partner?.username {
            self.currentPartnerName = partner
            self.isLoading = false
        } else {
            fetchPartnerRequests()
        }
    }

    private func fetchPartnerRequests() {
        PartnerService.shared.getPendingPartnerRequests { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let requests):
                    self.incomingRequest = requests.first
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
                self.isLoading = false
            }
        }
    }

    private func respondToRequest(action: String) {
        guard let requestId = incomingRequest?["id"] as? Int else { return }

        PartnerService.shared.respondToRequest(requestId: requestId, action: action) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.incomingRequest = nil
                    Task { await fetchPartnerInfo() }
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
        }
    }

    private func removePartner() {
        let url = URL(string: "https://tastebuds.unr.dev/api/remove-partner/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = UserDefaults.standard.string(forKey: "accessToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            self.errorMessage = "No access token found"
            self.showError = true
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    return
                }

                self.currentPartnerName = nil
                self.incomingRequest = nil
                Task { await fetchPartnerInfo() }
            }
        }.resume()
    }
}

#Preview {
    AddPartnerView()
        .environmentObject(NavigationState())
}
