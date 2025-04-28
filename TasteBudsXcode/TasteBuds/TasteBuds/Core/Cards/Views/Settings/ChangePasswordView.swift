//
//  ChangePasswordView.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 4/23/25.
//

import SwiftUI

struct ChangePasswordView: View {
    @State private var oldPassword = ""
    @State private var newPassword = ""
    @State private var confirmNewPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Form {
            Section(header: Text("Current Password")) {
                SecureField("Old Password", text: $oldPassword)
            }

            Section(header: Text("New Password")) {
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmNewPassword)
            }

            Button("Change Password") {
                if newPassword != confirmNewPassword {
                    alertMessage = "New passwords do not match."
                    showingAlert = true
                } else {
                    AuthService.shared.changePassword(oldPassword: oldPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success:
                                alertMessage = "Password changed successfully!"
                            case .failure(let error):
                                alertMessage = "Failed to change password: \(error.localizedDescription)"
                            }
                            showingAlert = true
                        }
                    }
                }
            }
        }
        .navigationTitle("Change Password")
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
