//APIService to fetch recipes from Django backend
import Foundation

class APIService {
    static let shared = APIService()
    let baseURL = "http://127.0.0.1:8000/tastebuds/allrecipe/"
    
    // Fetch recipes from the Django backend
    func fetchRecipes(completion: @escaping ([Recipe]?) -> Void) {
        let urlString = "\(baseURL)/recipes/"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recipes: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let recipes = try decoder.decode([Recipe].self, from: data)
                completion(recipes)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}
