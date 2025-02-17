//
//  Userdefaults.swift
//  ProjectMoviesApp
//
//  Created by Rodrigo on 17/02/25.
//

import Foundation

// Extensão para gerenciar filmes favoritos
extension UserDefaults {
    private enum Keys {
        static let favoriteMovies = "favoriteMovies"
    }
    
    // Salva a lista de filmes favoritos
    func saveFavoriteMovies(_ movies: [Movie]) {
        if let encodedData = try? JSONEncoder().encode(movies) {
            self.set(encodedData, forKey: Keys.favoriteMovies)
        }
    }
    
    // Carrega a lista de filmes favoritos
    func loadFavoriteMovies() -> [Movie] {
        if let savedData = self.data(forKey: Keys.favoriteMovies),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: savedData) {
            return decodedMovies
        }
        return []
    }
}
