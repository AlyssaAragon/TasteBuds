import SwiftUI

struct CardView: View {
    @ObservedObject var viewModel: CardsViewModel
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @StateObject private var recipeFetcher = RecipeFetcher()
    
    let model: CardModel

    var body: some View {
        ZStack(alignment: .bottom) {
            if let recipe = recipeFetcher.recipes.first {
                ZStack(alignment: .top) {
                    //recipe image, need "placeholder image asset"
                    if let recipeImage = model.recipe.recipeImage {
                        Image(recipeImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    } else {
                        // Placeholder if no image is available
                        Image("placeholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 5)
                    }
                    //swipe
                    SwipeActionIndicatorView(xOffset: $xOffset)
                        .padding()
                }
                
                RecipeInfoView(recipe: recipe)
                
            } else {
                Text("Loading recipes...")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        //ZStack End
        
        //triggers cases for swipe left/right
        .onReceive(viewModel.$buttonSwipeAction, perform: { action in
            guard let action = action else { return } // Ensure action is non-nil
            onReceiveSwipeAction(action)
        })

        
        //card view style and animation
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
//                .onAppear {
//                    recipeFetcher.fetchRecipes()
//                }
        )
    }
}

//swipe functionality
private extension CardView {
    func returnTocenter( ){
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight( ){
        withAnimation {
            xOffset = 500
            degrees = 12
        }
        viewModel.swipeRight()


    }
    
    func swipeLeft( ){
        withAnimation {
            xOffset = -500
            degrees = -12
        }
        viewModel.swipeLeft()
    }
    
    func onReceiveSwipeAction(_ action: SwipeAction?){
        guard let action else {return}
        
        let topCard = viewModel.cardModels.last
        
        //modify the comparison logic to compare the IDs explicitly
        if topCard?.recipe.id == model.recipe.id {
            switch action {
            case .reject:
                swipeLeft()
            case .like:
                swipeRight()
            }
        }

    }
}

private extension CardView{
    func onDragChanged(_ value: DragGesture.Value){
        xOffset = value.translation.width
        degrees = Double(value.translation.width/25)
    }
    
    func onDragEnded(_ value: DragGesture.Value){
        let width = value.translation.width
        
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            returnTocenter()
            return
        }
        
        if width >= SizeConstants.screenCutoff {
            swipeRight()
        }else{
            swipeLeft()
        }
    }
}

//#Preview {
//    CardView(viewModel: viewModel, model: CardModel(recipe: recipeFetcher))
//}
