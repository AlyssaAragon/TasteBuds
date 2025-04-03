//
//  AddRecipeView.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 3/27/25.
//
//im trying to add this but its not working
/*
 
 add to main tab view
 case .newRecipe:
     AddRecipeView(onDismiss: {
         selectedTab = .favorites
     })
 */

/*
import SwiftUI

struct AddRecipeView: View {
    var onDismiss: () -> Void = {}

    @State private var title = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var isLoading = false
    @State private var showError = false

    var body: some View {
        if isLoading {
            ProgressView("Saving Recipe...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        } else {
            NavigationView {
                Form {
                    Section(header: Text("Title")) {
                        TextField("Enter title", text: $title)
                    }

                    Section(header: Text("Ingredients")) {
                        TextEditor(text: $ingredients)
                            .frame(height: 120)
                    }

                    Section(header: Text("Instructions")) {
                        TextEditor(text: $instructions)
                            .frame(height: 120)
                    }

                    Section(header: Text("Photo")) {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                        }

                        Button("Choose Photo") {
                            showImagePicker = true
                        }
                    }

                    Button("Save Recipe") {
                        saveRecipe()
                    }

                    Button("Cancel") {
                        onDismiss()
                    }
                    .foregroundColor(.red)
                }
                .navigationTitle("New Recipe")
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
    }

    private func saveRecipe() {
        isLoading = true

        uploadRecipeWithImage(
            title: title,
            ingredients: ingredients,
            instructions: instructions,
            image: selectedImage
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    onDismiss()
                case .failure(let error):
                    print("Upload error: \(error)")
                    showError = true
                }
            }
        }
    }
}

func uploadRecipeWithImage(
    title: String,
    ingredients: String,
    instructions: String,
    image: UIImage?,
    completion: @escaping (Result<Void, Error>) -> Void
) {
    guard let url = URL(string: "https://tastebuds.unr.dev/api/private-recipes/") else {
        completion(.failure(URLError(.badURL)))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

    if let token = UserDefaults.standard.string(forKey: "authToken") {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    var body = Data()

    let params = [
        "title": title,
        "ingredients": ingredients,
        "instructions": instructions
    ]

    for (key, value) in params {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        body.append("\(value)\r\n")
    }

    if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"recipe.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
    }

    body.append("--\(boundary)--\r\n")
    request.httpBody = body

    URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }

        completion(.success(()))
    }.resume()
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
*/
