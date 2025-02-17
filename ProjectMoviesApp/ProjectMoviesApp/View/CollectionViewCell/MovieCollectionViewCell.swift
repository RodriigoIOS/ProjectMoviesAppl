import UIKit
import SDWebImage

// celula responsavel por mostrar os filmes.

class MovieCollectionViewCell: UICollectionViewCell {
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .red
        return button
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return label
    }()
    
    // Closure para notificar quando o botao de favoritos e pressionado
    
    var favoriteButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // action do botao de favorito
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
    
    }
    
    func configure(with movie: Movie, isFavorite: Bool) {
        titleLabel.text = movie.title
        favoriteButton.isSelected = isFavorite
        
        if let posterPath = movie.posterPath {
            let imageURLString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            posterImageView.sd_setImage(with: URL(string: imageURLString), placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    @objc func favoriteButtonPressed(){
        //alterna entre favoritado ou nao.
        favoriteButton.isSelected.toggle()
        
        //quando essa funcao for utilizada, esse metodo ira notificar a closure que ele sera utilizado
        favoriteButtonTapped?()
    }
}
