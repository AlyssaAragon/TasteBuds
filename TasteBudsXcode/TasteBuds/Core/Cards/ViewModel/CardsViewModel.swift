//
//  CardsViewModel.swift
//  TinderTemplate
//
//  Created by Ali on 11/04/24.
//

import Foundation

class CardsViewModel: ObservableObject {
    @Published var cardModels = [CardModel]( )
    
    private let service: CardService
    
    init(service: CardService){
        self.service = service
    }
    
    func fetchCardModels() async{
        do {
            self.cardModels = try await service.fetchCardModels()
        } catch {
            print("DEBUG: Failed to fetch cards with error: \(error)")
        }
    }
}
