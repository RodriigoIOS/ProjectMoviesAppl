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
    }

    // MARK: - UICollectionViewDataSource & Delegate
    extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.numberOfMovies()
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
            let movie = viewModel.movieAtIndex(indexPath.row)
            cell.configure(with: movie)
            return cell
        }
        
        // Detecta quando o usuário chega ao final da lista
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == viewModel.numberOfMovies() - 1 && viewModel.hasMorePages() {
                fetchMovies()
            }
        }
    }
