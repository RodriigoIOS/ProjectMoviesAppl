import Foundation

class MovieViewModel {
    private var movies: [Movie] = []
    private let apiKey = "5d271b812b3599137b7c2dedcf05c53e" // Substitua pela sua API Key
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchMovies(completion: @escaping () -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Erro na requisição: \(error?.localizedDescription ?? "Erro desconhecido")")
                return
            }
            
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                self?.movies = movieResponse.results
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Erro ao decodificar JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    func movieAtIndex(_ index: Int) -> Movie {
        return movies[index]
    }
}
