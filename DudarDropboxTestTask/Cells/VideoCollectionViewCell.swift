//
//  VideoCollectionViewCell.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 01.09.2023.
//

import UIKit
import AVFoundation
import AVKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VideoCollectionViewCell"
    public var infoDidTap: (FileInfo?) -> Void = {_ in}
    private var info: FileInfo?
    
    private lazy var buttonInfo: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "video.fill"), for: .normal)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var videoLayer: AVPlayerLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(buttonInfo) 
        setConstraints()
    }
    required init?(coder: NSCoder) { fatalError() }
       
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .black
        videoLayer?.frame = contentView.bounds
        contentView.bringSubviewToFront(buttonInfo)
    }
     
    override func prepareForReuse() {
        super.prepareForReuse()
        videoLayer = .none
        info = nil
//        contentView.layer.sublayers?.removeLast()
    }
     
    public func setCell(withVideo video: Video?){
        info = video?.infoFromWeb ?? video?.infoFromLocalUrt
        guard let url = video?.videoUrl else {
            contentView.layer.contents = UIImage(named: "errorImage")
            return
        }
        let player = AVPlayer(url: url)
        videoLayer = .init(player: player)
        if let videoLayer {
            contentView.layer.addSublayer(videoLayer)
        }
        player.play()
        player.volume = 0
     
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

