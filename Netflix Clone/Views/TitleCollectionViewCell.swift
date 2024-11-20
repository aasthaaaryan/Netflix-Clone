//
//  TitleCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Aastha Aaryan on 10/11/24.
//

import UIKit

import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let postImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(postImageView)
        
    }
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        postImageView.sd_setImage(with: url, completed: nil)
        
//        guard let url = URL(string: model) else {return}
//        postImageView.sd_setImage(with: url, completed: nil)
    }
}
