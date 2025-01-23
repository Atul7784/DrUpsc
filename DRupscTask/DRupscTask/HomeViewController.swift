
import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {

    private var collectionView: UICollectionView!
    private var images: [UnsplashImage] = []
    private var filteredImages: [UnsplashImage] = []
    private var favorites: [UnsplashImage] = []
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupSearchController()
        fetchImages()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 16, height: 200)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView.backgroundColor = .white

        view.addSubview(collectionView)
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func fetchImages() {
        let urlString = "https://api.unsplash.com/photos?client_id=oWoFLlWx_1qQPZUPpY7-VwU1NOaS3fwJm4HsIxXi6NQ"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }

            do {
                self.images = try JSONDecoder().decode([UnsplashImage].self, from: data)
                self.filteredImages = self.images
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print("Error decoding images: \(error)")
            }
        }.resume()
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredImages = images
            collectionView.reloadData()
            return
        }

        filteredImages = images.filter { $0.description?.contains(searchText) ?? false }
        collectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? favorites.count : filteredImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let image = indexPath.section == 0 ? favorites[indexPath.item] : filteredImages[indexPath.item]
        cell.configure(with: image, isFavorite: favorites.contains(image))
        cell.onFavoriteToggle = { [weak self] in
            guard let self = self else { return }
            if self.favorites.contains(image) {
                self.favorites.removeAll { $0 == image }
            } else {
                self.favorites.append(image)
            }
            self.collectionView.reloadData()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unexpected element kind")
        }

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        if favorites.isEmpty {
            header.titleLabel.text = indexPath.section == 0 ? "Favorites  (No favorites item)"
           : "All Images"
        }else{
            header.titleLabel.text = indexPath.section == 0 ? "Favorites" : "All Images"
        }
      
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = indexPath.section == 0 ? favorites[indexPath.item] : filteredImages[indexPath.item]
        let detailVC = DetailViewController(image: image)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

class HeaderView: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.frame = CGRect(x: 16, y: 0, width: frame.width - 32, height: frame.height)
        addSubview(titleLabel)
    }
}
