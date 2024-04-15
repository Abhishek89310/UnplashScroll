//
//  APIMaster.swift
//  UnsplashScroll
//
//  Created by Matrix on 13/04/24.
//
import UIKit

class UnsplashAPI {
    static let shared = UnsplashAPI()
    
    private let baseURL = "https://api.unsplash.com/photos/"
    
    private var cache = NSCache<NSString, NSArray>()
    
    private var accessKey: String {
      get {
        // 1
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
          fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "accessKey") as? String else {
          fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
        }
          print("api_key",value)
        return value
      }
    }
    
    
    func downloadImages(page: Int, perPage: Int, completion: @escaping ([UIImage]?, Error?) -> Void) {
        let urlString = "\(baseURL)?client_id=\(accessKey)&page=\(page)&per_page=\(perPage)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        // Check cache
        if let cachedImages = getCachedImages(for: urlString) {
            completion(cachedImages as? [UIImage], nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                var downloadedImages: [UIImage] = []
                let group = DispatchGroup()
                
                for photo in photos {
                    group.enter()
                    self.downloadImage(urlString: photo.urls.thumb) { image, error in
                        defer { group.leave() }
                        guard let image = image else { return }
                        downloadedImages.append(image)
                    }
                }
                
                group.notify(queue: .main) {
                    // Cache images
                    self.cacheImages(downloadedImages, for: urlString)
                    completion(downloadedImages, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    private func downloadImage(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(UIImage(systemName: "square.and.arrow.up.trianglebadge.exclamationmark"), NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }.resume()
    }
    
    private func cacheImages(_ images: [UIImage], for key: String) {
        cache.setObject(images as NSArray, forKey: NSString(string: key))
    }

    private func getCachedImages(for key: String) -> NSArray? {
        return cache.object(forKey: NSString(string: key))
    }
}
