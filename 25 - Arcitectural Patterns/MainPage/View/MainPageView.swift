//
//  MainPageView.swift
//  25 - Arcitectural Patterns
//
//  Created by Ani's Mac on 17.11.23.
//

import UIKit

class MoviesCollectionView: UIView {
    let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

class MoviesListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = MoviesViewModel()
    private var moviesCollectionView: MoviesCollectionView!
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        return imageView
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("Profile", for: .normal)
        button.backgroundColor = UIColor(red: 252/255.0, green: 109/255.0, blue: 25/255.0, alpha: 1)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return button
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupMoviesCollectionView()
        fetchMovies()
    }
    
    // MARK: - Private Methods
    private func setup() {
        view.backgroundColor = UIColor(red: 26/255.0, green: 34/255.0, blue: 50/255.0, alpha: 1)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let logoItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoItem
        
        let profileButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.rightBarButtonItem = profileButtonItem
    }
    
    private func setupMoviesCollectionView() {
        moviesCollectionView = MoviesCollectionView(frame: view.bounds)
        moviesCollectionView.collectionView.dataSource = self
        moviesCollectionView.collectionView.delegate = self
        moviesCollectionView.collectionView.register(MovieItemCollectionViewCell.self, forCellWithReuseIdentifier: "MovieItemCell")
        
        view.addSubview(moviesCollectionView)
    }
    
    private func fetchMovies() {
        viewModel.fetchMovies { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.moviesCollectionView.collectionView.reloadData()
                }
            } else {
                return
            }
        }
    }
}

// MARK: - CollectionView DataSource
extension MoviesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfMovies
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieItemCell", for: indexPath) as? MovieItemCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.movieAtIndex(indexPath.row)
        viewModel.loadImage(for: movie) { image in
            DispatchQueue.main.async {
                cell.configure(with: movie, image: image!)
            }
        }
        return cell
    }
}

// MARK: - CollectionView FlowLayoutDelegate
extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing
        let width = Int((collectionView.bounds.width - totalSpace) / 2)
        let height = 280
        
        return CGSize(width: width, height: height)
    }
}


