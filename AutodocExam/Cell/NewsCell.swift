//
//  NewsCell.swift
//  AutodocExam
//
//  Created by ESSIP on 26.03.2025.
//

import Foundation
import UIKit

final class NewsCell: UICollectionViewCell {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.image = UIImage(systemName: "photo")
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    
    static var reuseIdentifier: String { String(describing: self) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -UI
    
    private func setupUI(){
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    //MARK: -Конфигурация
    
    func configure(with news: NewsElement){
        self.titleLabel.text = news.title
        loadImage(from: news.titleImageURL)
    }
    
    //MARK: -Загрузка изображения
    
    func loadImage(from urlString: String?){
        
        self.imageView.image = UIImage(systemName: "photo")
        
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        if let cachedImage = NewsCell.imageCache.object(forKey: urlString as NSString){
            self.imageView.image = cachedImage
            return
        }
        
        let currentTag = urlString.hashValue
        self.tag = currentTag
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    if self.tag == currentTag {
                        NewsCell.imageCache.setObject(image, forKey: urlString as NSString)
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
