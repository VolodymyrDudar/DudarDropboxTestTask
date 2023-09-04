//
//  SectionHeaderView.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "SectionHeaderView1"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = .blue 
        return label
    }()
     
    private let lineView  = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [label, lineView ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            label.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -2),
            
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 2 / UIScreen.main.scale),
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let grLayer = CAGradientLayer()
        let grColors: [UIColor] = [.gray, .gray, .white.withAlphaComponent(0)]
        grLayer.colors = grColors.map{ $0.cgColor }
        grLayer.startPoint = CGPoint(x: 0, y: 1)
        grLayer.endPoint = CGPoint(x: 1, y: 1)
        grLayer.frame = lineView.layer.bounds
        lineView.layer.addSublayer(grLayer)
    }
    
    func setTitle(_ title: String) {
        label.text = title 
    }
    
}

