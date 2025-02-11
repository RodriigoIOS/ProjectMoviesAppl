import Foundation

class MovieViewModel {
    private var movies: [Movie] = []
    private let apiKey = "5d271b812b3599137b7c2dedcf05c53e"
    private let baseURL = "https://api.themoviedb.org/3"
    private var currentPage = 1
    private var totalPages = 1
    
    
    // Busca os filmes da página atual
    func fetchMovies(completion: @escaping () -> Void) {
        let urlString = "\(baseURL)/movie/popular?api_key=\(apiKey)&page=\(currentPage)"
        
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
                self?.movies.append(contentsOf: movieResponse.results)
                self?.currentPage += 1
                self?.totalPages = movieResponse.totalPages
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Erro ao decodificar JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // Verifica se há mais páginas para carregar
    func hasMorePages() -> Bool {
        return currentPage <= totalPages
    }
    
    // Retorna o número de filmes carregados
    func numberOfMovies() -> Int {
        return movies.count
    }
    
    // Retorna o filme no índice especificado
    func movieAtIndex(_ index: Int) -> Movie {
        return movies[index]
    }
}
