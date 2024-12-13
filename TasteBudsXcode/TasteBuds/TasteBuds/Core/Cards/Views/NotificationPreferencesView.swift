//
//  NotificationPreferencesView.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 12/13/24.
//
// on the main settings page, the notification settings button will lead here
import SwiftUI


struct NotificationPreferencesView: View {
   @State private var notifications: Bool = true
   @State private var recipeSuggestions: Bool = true
   @State private var favoriteUpdates: Bool = false
   @State private var partnerActivity: Bool = false
   @State private var partnerMatches: Bool = false
   @State private var appUpdates: Bool = false

   var body: some View {
       NavigationView {
           Form {
               Section(header: Text("Notification Settings")) {
                   Toggle("Enable Notifications", isOn: $notifications)
               }


               if notifications {
                   Section(header: Text("Notification Types")) {
                       Toggle("Recipe Suggestions", isOn: $recipeSuggestions)
                       Toggle("Favorite Updates", isOn: $favoriteUpdates)
                       Toggle("Partner Activity", isOn: $partnerActivity)
                       Toggle("Partner Matches", isOn: $partnerMatches)
                       Toggle("App Updates", isOn: $appUpdates)
                   }
               }
           }
           .navigationTitle("Notification Preferences")
       }
   }
}


struct NotificationPreferencesView_Previews: PreviewProvider {
   static var previews: some View {
       NotificationPreferencesView()
   }
}



