//
//  PartnerSetupView.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/2/24.
// NOT DONE yet but just trying to get a basic design on here (Alyssa)
import SwiftUI
struct PartnerSetupView: View {
    @State private var partnerName: String = ""
    @State private var partnerEmail: String = ""
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
                    
                Spacer()
                 
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
                    // Button to send the invitation
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
    }
        
    private func sendInvitation() {
        print("Invitation sent to \(partnerName) at \(partnerEmail)")
            
    }
}
    
struct PartnerSetupView_Previews: PreviewProvider {
    static var previews: some View {
        PartnerSetupView()
    }
}


#Preview {
    PartnerSetupView()
}
