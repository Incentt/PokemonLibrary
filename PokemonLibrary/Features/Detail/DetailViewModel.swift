//
//  DetailViewModel.swift
//  PokemonLibrary
//
//  Created by Vincent Wisnata on 08/05/25.
//
import Foundation
import SwiftUI

final class DetailViewModel: ObservableObject {
    @Published private(set) var name: String = ""
    @Published private(set) var abilities: [String] = []
    @Published private(set) var height: String = ""
    @Published private(set) var weight: String = ""
    @Published private(set) var image: Image? = nil
    @Published var isLoading: Bool = true
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    func loadPokemonDetail(_ pokemon: Pokemon) {
        isLoading = true
        showError = false
        errorMessage = ""

        Task { 
            do {
                let detail: PokemonDetailResponse = try await NetworkService().request(.getPokemonDetail(urlString: pokemon.url))
                
                DispatchQueue.main.async {
                    self.name = detail.name.capitalized
                    self.height = "\(detail.height) cm"
                    self.weight = "\(detail.weight) kg"
                    self.abilities = detail.abilities.map { $0.ability.name.capitalized }
                    self.isLoading = false
                }

                if let imageUrl = URL(string: detail.sprites.other.officialArtwork.url) {
                    loadImage(from: imageUrl)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showError = true
                    if let networkError = error as? NetworkError {
                        self.errorMessage = networkError.errorDescription ?? "Unknown error"
                    } else {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    private func loadImage(from url: URL) {
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: uiImage)
                    }
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
}
