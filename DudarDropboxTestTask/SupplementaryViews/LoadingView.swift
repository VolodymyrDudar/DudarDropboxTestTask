//
//  LoadingView.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 04.09.2023.
//

import UIKit

class LoadingView: UIView {
    
    private let blueColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "loading"
        label.font = UIFont.systemFont(ofSize: 19, weight: .light)
        label.textColor = blueColor
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = blueColor
        return activityIndicator
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [ activityIndicator, loadingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 6),
            activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            
            loadingLabel.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: activityIndicator.leadingAnchor, constant: -8),
            loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 53)
        ])
       stopAnimation()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    public func startAnimation() {
        loadingLabel.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func stopAnimation() {
        loadingLabel.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
}
