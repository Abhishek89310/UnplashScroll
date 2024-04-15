//
//  ImageCell.swift
//  UnsplashScroll
//
//  Created by Matrix on 14/04/24.
//

import UIKit

class ImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    let cellNumberLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.backgroundColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.layer.cornerRadius = 7
            label.layer.masksToBounds = true
            return label
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(cellNumberLabel)
        addSubview(imageView)
        imageView.addSubview(cellNumberLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        cellNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            cellNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            cellNumberLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
