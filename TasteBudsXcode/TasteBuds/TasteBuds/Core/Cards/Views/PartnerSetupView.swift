//
//  PartnerSetupView.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/2/24.

import SwiftUI
struct PartnerSetupView: View {
    @State private var partnerName: String = ""
    @State private var partnerEmail: String = ""
    @State private var showAlert: Bool = false
    var body: some View {
        ZStack {
               
            Color(red: 0.66, green: 0.31, blue: 0.33)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    NavigationLink(destination: AddPartnerView()) {
                        Text("Cancel")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(width: 120, height: 37)
                    .padding(.trailing, 20)
                    .offset(y: 50)
                }
                    
                Image("partnersetupimg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.top, 30)
                 
                Text("Invite Your TasteBud")
                    .font(Font.custom("Abyssinica SIL", size: 27))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 5)
                    .padding(.bottom, 20)
                VStack(spacing: 20) {
                    TextField("Partner's Name", text: $partnerName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .font(.custom("Abyssinica SIL", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                    TextField("Partner's Email", text: $partnerEmail)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)
                        .font(.custom("Abyssinica SIL", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 30)
                Button(action: {
                    sendInvitation()
                }) {
                    Text("Send Invitation")
                        .font(Font.custom("Abyssinica SIL", size: 26))
                        .foregroundColor(.black)
                        .frame(width: 314, height: 70)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 10)
                }
                    
                Spacer()
            }
            .frame(width: 414, height: 896)
            
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Invitation Sent"),
                          message: Text("The invitation has been sent successfully!"),
                          dismissButton: .default(Text("OK")))
        }
    }
        
    private func sendInvitation() {
        showAlert = true

            
    }
}
    


#Preview {
    PartnerSetupView()
}
