//
//  NetworkPath.swift
//  PokemonLibrary
//
//  Created by Jessi Febria on 30/04/25.
//

import Foundation

enum NetworkPath {
    case getPokemons
    case getPokemonDetail(urlString: String)
    
    var url: URL? {
        switch self {
        case .getPokemons:
            return URL(string: "https://pokeapi.co/api/v2/pokemon?limit=400")
        case .getPokemonDetail(let urlString):
            return URL(string: urlString)
        }
    }
}
