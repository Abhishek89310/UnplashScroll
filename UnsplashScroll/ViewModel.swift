//
//  ViewModel.swift
//  UnsplashScroll
//
//  Created by Matrix on 14/04/24.
//

import UIKit

protocol ImageCollectionViewModelProtocol: AnyObject {
    var images: [UIImage] { get }
    var isLoading: Bool { get }
    
    func loadImages(completion: @escaping (Error?) -> Void)
}

class ImageCollectionViewModel: ImageCollectionViewModelProtocol {
    // MARK: - Properties
    var images: [UIImage] = []
    var currentPage = 1
    var isLoading = false
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Image Loading
    func loadImages(completion: @escaping (Error?) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        
        
        UnsplashAPI.shared.downloadImages(page: currentPage, perPage: 10) { [weak self] downloadedImages, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                self.isLoading = false
                return
            }
            
            if let downloadedImages = downloadedImages {
                self.images.append(contentsOf: downloadedImages)
                self.isLoading = false
                self.currentPage += 1
                completion(nil)
            }
        }
    }
}
