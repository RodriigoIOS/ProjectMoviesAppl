//
//  FavouritesMovieViewController.swift
//  ProjectMoviesApp
//
//  Created by Rodrigo on 11/02/25.
//

import UIKit

class FavoriteViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var favoriteMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        loadFavoriteMovies()
        
        // Observa a notificação de atualização de favoritos
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(handleFavoriteUpdate),
                    name: .didUpdateFavorites,
                    object: nil
                )
    }
    
    deinit{
        // Remove o observador quando a tela for destruída
                NotificationCenter.default.removeObserver(self, name: .didUpdateFavorites, object: nil)
    }
    
    // Configura a collection view
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width / 2 - 15, height: 300)
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
    
    // Carrega os filmes favoritos do UserDefaults
    private func loadFavoriteMovies() {
        favoriteMovies = UserDefaults.standard.loadFavoriteMovies()
        collectionView.reloadData()
    }
    
    // Método chamado quando a notificação é recebida
    @objc private func handleFavoriteUpdate() {
        loadFavoriteMovies()
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCollectionViewCell
        let movie = favoriteMovies[indexPath.row]
        cell.configure(with: movie, isFavorite: true)
        return cell
    }
}
