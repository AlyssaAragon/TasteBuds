import SwiftUI
// the design of this looks bad rn it needs to be fixed so it looks cuter
struct CardView: View {
    @State private var currentRecipe: FetchedRecipe? = nil
    @State private var nextRecipe: FetchedRecipe? = nil
    private let recipeFetcher = RecipeFetcher()

    @State private var offset = CGSize.zero
    @State private var dragAmount = CGSize.zero
    @State private var isSwiped = false
    
    var body: some View {
        ZStack {
            Color(red: 0.66, green: 0.31, blue: 0.33)
                .edgesIgnoringSafeArea(.top)
                .frame(maxHeight: .infinity)
                .overlay(
                    VStack {
                        Text("TasteBuds")
                            .font(Font.custom("Abyssinica SIL", size: 45))
                            .foregroundColor(Color(red: 0.86, green: 0.87, blue: 0.93))
                            .padding(.top, 20)
                        Spacer()
                    }
                )

            VStack {
                Spacer().frame(height: 100)
                if let recipe = currentRecipe {
                    VStack {

                        if let recipeImage = recipe.recipeImage,
                           let url = URL(string: recipeImage) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                Image("placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            Image("placeholder")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }


                        Text(recipe.name)
                            .bold()
                            .font(Font.custom("Abyssinica SIL", size: 35))
                            .padding(.top, 20)


                        Text(recipe.description)
                            .font(.body)
                            .padding(.top, 5)
                        //we need to format the ingredients to look better
                        Text(recipe.ingredients)
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                    .offset(x: dragAmount.width, y: dragAmount.height)
                    .gesture(DragGesture()
                                .onChanged { value in
                                    self.dragAmount = value.translation
                                }
                                .onEnded { value in
                                    if abs(value.translation.width) > 150 {
                                        // If dragged enough, consider it a swipe
                                        self.isSwiped = true
                                    } else {
                                        // Reset drag if not swiped enough
                                        self.dragAmount = .zero
                                    }
                                })
                } else {
                    // No recipe available
                    Text("No recipe available")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                Spacer()

                //buttons for swiping actions
                HStack {
                    Button(action: {
                        //Handle X (swipe left) action
                        print("Swiped left")
                        Task {
                            await fetchNextRecipe()
                        }
                    }) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.title)
                            )
                    }
                    .padding(.leading, 40)

                    Spacer()

                    Button(action: {
                        //Handle heart (swipe right) action
                        print("Swiped right")
                        Task {
                            await fetchNextRecipe()
                        }
                    }) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.white)
                                    .font(.title)
                            )
                    }
                    .padding(.trailing, 40)
                }
                .padding(.bottom, 40) //Padding for the bottom
            }
        }
        .onAppear {
            Task {
                await fetchRecipe()
            }
        }
        .onChange(of: isSwiped) { _ in
            // Fetch next recipe after swipe
            if isSwiped {
                Task {
                    await fetchNextRecipe()
                }
            }
        }
    }

    //Fetch the current recipe directly from RecipeFetcher
    private func fetchRecipe() async {
        await recipeFetcher.fetchRecipe()
        if let fetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = fetchedRecipe
        }
    }

    //fetch the next recipe to replace the current one
    private func fetchNextRecipe() async {
        // Reset swipe state and drag amount
        self.isSwiped = false
        self.dragAmount = .zero

        // Fetch the next recipe (this should be based on your data source or API)
        await recipeFetcher.fetchRecipe()
        if let nextFetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = nextFetchedRecipe
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
