//
//  DetailView.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 06/05/25.
//

import SwiftUI
import Foundation

struct DetailView: View {
    let pokemon: Pokemon
    @StateObject private var viewModel = DetailViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
            else if viewModel.showError {
                Text("Error: \(viewModel.errorMessage)")
                    .padding()
            }
            else {
                if let pokemonImage = viewModel.image {
                    pokemonImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .padding()
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                        .padding()
                }

                VStack(spacing: 8.0) {
                    Text(viewModel.name)
                        .font(.title2)
                        .bold()
                        .padding(.top, 8.0)
                    
                    Text("Height: \(viewModel.height)")
                    Text("Weight: \(viewModel.weight)")
                    
                    if !viewModel.abilities.isEmpty {
                        Text("Abilities:")
                            .font(.title3)
                            .bold()
                            .padding(.top, 16.0)
                        
                        ForEach(viewModel.abilities, id: \.self) { ability in
                            Text(ability)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Pokémon Details")
        .onAppear {
            viewModel.loadPokemonDetail(pokemon)
        }
    }
}
