////
////  AuthenticatedAPICalloutTest.swift
////  TasteBuds
////
////  Created by Ali on 12/9/24.
////
//
//import SwiftUI
//
//struct AuthenticatedAPICalloutTest: View {
//    @State var accounts = [Account]()
//    var body: some View {
//        ForEach(accounts, id: \.self) {item in
//            HStack {
//                
//                Text(item.name)
//                Spacer()x
//                Text ("\(item.balance)")
//            }
//        }.onAppear(perform: loadAccount)
//    }
//    
//    func loadAccount(){
//        guard let url = URL(string: "http://127.0.0.1:8000/api/account/") else {
//            print ("api is down")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.addValue ("application/json", forHTTPHeaderField:"Accept")
//        request.addValue ("Basic cGF1bG9vcnF1aWxsbzpwYWRtYUAxMTU=", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                if let response = try? JSONDecoder().decode([Account].self, from: data){
//                    DispatchQueue.main.async{
//                        self.accounts = response
//                    }
//                    return
//                }
//            }
//        }.resume()
//    }
//}
//
//#Preview {
//    AuthenticatedAPICalloutTest()
//}
