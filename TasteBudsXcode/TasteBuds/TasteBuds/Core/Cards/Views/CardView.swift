import SwiftUI

struct CardView: View {
    @State private var currentRecipe: FetchedRecipe? = nil
    @State private var nextRecipe: FetchedRecipe? = nil
    private let recipeFetcher = RecipeFetcher()

    @State private var offset = CGSize.zero
    @State private var dragAmount = CGSize.zero
    @State private var isSwiped = false
    @EnvironmentObject var favoritesManager: FavoritesManager
    
    var body: some View {
        ZStack {
            Color(red: 0.66, green: 0.31, blue: 0.33)
                .edgesIgnoringSafeArea(.top)
                .frame(maxHeight: .infinity)
                .overlay(
                    VStack {
                        Text("TasteBuds")
                            .font(Font.custom("Abyssinica SIL", size: 40))
                            .foregroundColor(Color(red: 0.86, green: 0.87, blue: 0.93))
                            .padding(.top, 40)
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
                                    .frame(width: 350, height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                Image("placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 350, height: 250)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        } else {
                            Image("placeholder")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 350, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }

                        Text(recipe.name)
                            .bold()
                            .font(Font.custom("Abyssinica SIL", size: 40))
                            .foregroundColor(Color(red: 0.86, green: 0.87, blue: 0.93))
                            .padding(.top, 20)

                        Text(recipe.description)
                            .font(.body)
                            .padding(.top, 5)
                    }
                    .padding()
                    .frame(width: 350, height: 400)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white).shadow(radius: 5))
                    .offset(x: dragAmount.width, y: dragAmount.height)
                    .gesture(DragGesture()
                                .onChanged { value in
                                    self.dragAmount = value.translation
                                }
                                .onEnded { value in
                                    if abs(value.translation.width) > 150 {
                                        self.isSwiped = true
                                    } else {
                                        self.dragAmount = .zero
                                    }
                                })
                } else {
                    Text("No recipe available")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                Spacer()

                HStack {
                    Button(action: {
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
                        print("Swiped right")
                        if let currentRecipe = currentRecipe {
                            favoritesManager.addFavorite(currentRecipe)
                        }
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
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            Task {
                await fetchRecipe()
            }
        }
        // Weird warning here idk what it means
        .onChange(of: isSwiped) { _ in
            if isSwiped {
                Task {
                    await fetchNextRecipe()
                }
            }
        }
    }

    private func fetchRecipe() async {
        await recipeFetcher.fetchRecipe()
        if let fetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = fetchedRecipe
        }
    }

    private func fetchNextRecipe() async {
        self.isSwiped = false
        self.dragAmount = .zero

        await recipeFetcher.fetchRecipe()
        if let nextFetchedRecipe = recipeFetcher.currentRecipe {
            self.currentRecipe = nextFetchedRecipe
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
            .environmentObject(FavoritesManager())
    }
}
