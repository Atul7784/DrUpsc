import UIKit

class DetailViewController: UIViewController {
    private let image: UnsplashImage
    private let imageView = UIImageView()
    private let shareButton = UIButton()

    init(image: UnsplashImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        ImageLoader.shared.loadImage(from: image.url) { [weak self] image in
            self?.imageView.image = image
        }

        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.white, for: .normal)
        shareButton.backgroundColor = .systemBlue
        shareButton.layer.cornerRadius = 5
        shareButton.frame = CGRect(x: 20, y: view.frame.height - 80, width: 100, height: 40)
        shareButton.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        view.addSubview(shareButton)
    }

    @objc private func shareImage() {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}
