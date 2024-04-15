//
//  Helper.swift
//  UnsplashScroll
//
//  Created by Matrix on 15/04/24.
//

import UIKit

class UIHelper {
    static let shared = UIHelper()
    
    private init() {}
    
    private var activityIndicator: UIActivityIndicatorView?
    
    func showActivityIndicator(on view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator = UIActivityIndicatorView(style: .large)
            self.activityIndicator?.center = view.center
            view.addSubview(self.activityIndicator!)
            self.activityIndicator?.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
        }
    }
    
    func showErrorAlert(on viewController: UIViewController, with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
