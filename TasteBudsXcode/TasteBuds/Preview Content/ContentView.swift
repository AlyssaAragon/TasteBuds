import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            //this is the inital launch screen i think were supposed to do soemthing with 
            //the storyboard but idk how that works AT ALL but apparenly apple products use that for something idk
            Text("Welcome to TasteBuds!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        .onAppear {
            
        }
    }
}

#Preview {
    ContentView()
}
