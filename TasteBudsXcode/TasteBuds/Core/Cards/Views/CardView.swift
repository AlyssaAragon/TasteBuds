import SwiftUI

struct CardView: View {
    let recipe: Recipe
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    // @StateObject private var recipeFetcher = RecipeFetcher()
    let recipe: FetchedRecipe

    var body: some View {
        ZStack(alignment: .bottom) {
            if let recipe = recipeFetcher.recipes.first {
                ZStack(alignment: .top) {
                    //place holder for recipe image
                    Color.gray
                        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 5)
                    //swipe
                    SwipeActionIndicatorView(xOffset: $xOffset)
                        .padding()
                }
                
                RecipeInfoView(recipe: recipe)
                    .padding(.horizontal)
                    .frame(width: SizeConstants.cardWidth)

                //buttons
                HStack {
                    Button(action: swipeLeft) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                    Spacer()
                    Button(action: swipeRight) {
                        Image(systemName: "heart.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    }
                }
                .padding()
            } else {
                Text("Loading recipes...")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
        .onAppear {
            Task{
                await recipeFetcher.fetchRecipes()
            }
        }
    }
}

//swipe functionality
private extension CardView {
    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }

    func swipeRight() {
        xOffset = 500
        degrees = 12
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Notify parent view to handle card removal
        }
    }

    func swipeLeft() {
        xOffset = -500
        degrees = -12
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // Notify parent view to handle card removal
        }
    }

    func onDragChanged(_ value: DragGesture.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }

    func onDragEnded(_ value: DragGesture.Value) {
        let width = value.translation.width
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            returnToCenter()
            return
        }

        if width >= SizeConstants.screenCutoff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
}
