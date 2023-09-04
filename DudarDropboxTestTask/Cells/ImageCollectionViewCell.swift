//
//  ImageCollectionViewCell.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 31.08.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
//
    static let identifier = "ImageCollectionViewCell"
    
    public var infoDidTap: (FileInfo?) -> Void = {_ in}
    private var info: FileInfo?
    
    let spiner = UIActivityIndicatorView(style: .large)
    
    private lazy var buttonInfo: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        spiner.startAnimating()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(buttonInfo)
        imageView.addSubview(spiner)
        setConstraints()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
        spiner.center = imageView.center
        spiner.color = .black
    }
    
    public func set(image: Image?){
        info = image?.info
        if let image = image?.image {
            imageView.image = image
            spiner.stopAnimating()
        }else {
            imageView.image = UIImage(named: "errorImage")
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        spiner.stopAnimating()
        info = nil
    }
    
    @objc private func infoButtonDidTap () {
        infoDidTap(info)
    }
    
    private func setConstraints() {
        buttonInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonInfo.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            buttonInfo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            buttonInfo.heightAnchor.constraint(equalToConstant: 16),
            buttonInfo.widthAnchor.constraint(equalToConstant: 32),
        ])
    }
}

