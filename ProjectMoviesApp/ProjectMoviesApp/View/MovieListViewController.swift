import UIKit

class MovieListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let viewModel = MovieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchMovies()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width / 2 - 15, height: 300) // 2 colunas
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        view.addSubview(collectionView)
    }
    
    private func fetchMovies() {
        viewModel.fetchMovies { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // Verifica se um filme está na lista de favoritos
    private func isMovieFavorite(_ movie: Movie) -> Bool {
        let favoriteMovies = UserDefaults.standard.loadFavoriteMovies()
        return favoriteMovies.contains { $0.id == movie.id }
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = viewModel.movieAtIndex(indexPath.row)
        
        // Verifica se o filme está favoritado
        let isFavorite = isMovieFavorite(movie)
        
        // Configura a célula com o filme e o estado de favorito
        cell.configure(with: movie, isFavorite: isFavorite)
        
        // Define a ação do botão de favorito
        cell.favoriteButtonTapped = { [weak self] in
            self?.toggleFavorite(movie: movie)
            cell.configure(with: movie, isFavorite: self?.isMovieFavorite(movie) ?? false)
        }
        
        return cell
    }
    
    // Alterna o estado de favorito de um filme
    private func toggleFavorite(movie: Movie) {
            var favoriteMovies = UserDefaults.standard.loadFavoriteMovies()
            
            if let index = favoriteMovies.firstIndex(where: { $0.id == movie.id }) {
                // Remove o filme da lista de favoritos
                favoriteMovies.remove(at: index)
            } else {
                // Adiciona o filme à lista de favoritos
                favoriteMovies.append(movie)
            }
            
            // Salva a lista atualizada no UserDefaults
            UserDefaults.standard.saveFavoriteMovies(favoriteMovies)
            
            // Envia uma notificação para atualizar a tela de favoritos
            NotificationCenter.default.post(name: .didUpdateFavorites, object: nil)
        }
}

extension Notification.Name {
    static let didUpdateFavorites = Notification.Name("didUpdateFavorites")
}
