//
//  ImageViewController.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit

class ImageViewController: UIViewController {
    
    private var presenter: ImageViewPresenterOut!
    private var info: FileInfo?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit 
        return imageView
    }()
    
    private lazy var buttonInfo: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "info.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 33)), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(infoButtonDidTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(buttonInfo)
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.viewDidAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds
    }
    
    init(presenter: ImageViewPresenterOut = ImageViewPresenterImpl()) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.presenter.view = self
    }
    required init?(coder: NSCoder) { fatalError( )}
    
    private func setConstraints() {
        buttonInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonInfo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            buttonInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            buttonInfo.heightAnchor.constraint(equalToConstant: 33),
            buttonInfo.widthAnchor.constraint(equalToConstant: 33),
        ])
    }
    
    @objc private func infoButtonDidTap () {
        if let info {
            showAlerd(withDataInfo: info, withAlertStyle: .actionSheet)
        }
    }
}

extension ImageViewController: ImageViewPresenter {
    func get(image: UIImage, dataInfo: FileInfo?) {
        imageView.image = image
        info = dataInfo
    }
     
}

