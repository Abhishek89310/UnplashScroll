//
//  ViewController.swift
//  UnsplashScroll
//
//  Created by Matrix on 13/04/24.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var viewModel: ImageCollectionViewModelProtocol = ImageCollectionViewModel()
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadImages()
    }
    
    // MARK: - Private Methods
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func loadImages() {
        // Show activity indicator
        UIHelper.shared.showActivityIndicator(on: view)
        viewModel.loadImages { [weak self] error in
            guard let self = self else { return }
            // Hide activity indicator
            UIHelper.shared.hideActivityIndicator()
            if let error = error {
                UIHelper.shared.showErrorAlert(on: self, with: "\(error.localizedDescription),may be limit reached")
                return
            }
            
            self.collectionView.reloadData()
        }
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = UIImage()
        cell.imageView.image = viewModel.images[indexPath.item]
        cell.cellNumberLabel.text = "\(indexPath.item)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 3
        let spacingBetweenCells: CGFloat = 10
        let totalSpacing = (numberOfColumns - 1) * spacingBetweenCells
        let width = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        let image = viewModel.images[indexPath.item]
        let aspectRatio = image.size.width / image.size.height
        let height = width / aspectRatio
        return CGSize(width: width, height: height)
    }

}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.images.count - 3 { // Load more when reaching the last cell
            loadImages()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
            collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            return 10
        }
}

