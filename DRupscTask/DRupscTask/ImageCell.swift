import UIKit

class ImageCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    let favoriteButton = UIButton()
    var onFavoriteToggle: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Configure imageView
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        // Configure nameLabel
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        // Configure favoriteButton
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        contentView.addSubview(favoriteButton)

        // Add constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
           
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func toggleFavorite() {
        onFavoriteToggle?()
    }

    func configure(with image: UnsplashImage, isFavorite: Bool) {
        // Set image
        if let url = URL(string: image.url) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }

        // Set name
        nameLabel.text = image.description ?? "No Name"

        // Update favoriteButton state
        let favoriteIcon = isFavorite ? "heart.fill" : "heart"
       
        if isFavorite == true {
            favoriteButton.tintColor = .systemRed
        }else{
            favoriteButton.tintColor = .white
        }
        favoriteButton.setImage(UIImage(systemName: favoriteIcon), for: .normal)

        // Set favorite state background (optional for styling)
 contentView.backgroundColor =  UIColor.systemYellow.withAlphaComponent(0.3) 
    }
}
