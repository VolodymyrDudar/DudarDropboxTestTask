//
//  CollectionViewController.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 31.08.2023.
//

import UIKit
 
class CollectionViewController: UIViewController {
   
    private var mediaItems = [Item]() {
        didSet { collectionView.reloadData() }
    }
     public var presenter: CollectionViewPresetnerOut! {
        didSet { presenter.view = self }
    }
    
    private let loadingView = LoadingView()
    private lazy var logoutButton = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(logoutButtonTapped))
       
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(VideoCollectionViewCell.self,
                                forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white.withAlphaComponent(0)
        return collectionView
    }()
 
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.startAnimation()
        view.addSubview(collectionView)
        navigationItem.rightBarButtonItem = logoutButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: loadingView)
        setConstraints()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidAppear()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
        setCollectionLayout()
    }
     
}

private extension CollectionViewController {
    //MARK: SetCollectionLayout
    func setCollectionLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        let itemWidth: CGFloat
        let itemHeight: CGFloat
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            itemWidth = (collectionView.bounds.height / 3) - 1
            itemHeight = collectionView.bounds.height / 2
        default:
            itemWidth = (collectionView.bounds.width / 3) - 1
            itemHeight = collectionView.bounds.width / 2
        }
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.headerReferenceSize = CGSize(width: collectionView.bounds.width * 0.92,
                                                height: collectionView.bounds.height * 0.1)
        collectionView.collectionViewLayout = flowLayout
    }
 
    //MARK: Actions
    @objc private func logoutButtonTapped() { 
        presenter.logoutButtonTapped() { res in
            switch res {
            case .success(_):
                navigationController?.pushViewController(LoginViewController(), animated: true)
                navigationController?.viewControllers.removeFirst()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    //MARK: setConstraints
    private func setConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
}
 
//MARK: Presenter
extension CollectionViewController: CollectionViewPresetner {
    
    func present(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true )
    }
    
    func setCollection(withMediaFiles files: [Item]) {
        mediaItems = files
        loadingView.stopAnimation()
    }
     
}

//MARK: CollectionDataSource
extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { mediaItems.count }
     
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = mediaItems[indexPath.row]
        switch item {
        case .image(let image):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier,
                                                          for: indexPath) as! ImageCollectionViewCell
            cell.set(image: image)
            cell.infoDidTap = { self.showAlerd(withDataInfo: $0) }
            return cell
        case .videoUrl(let video):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier,
                                                          for: indexPath) as! VideoCollectionViewCell
            cell.setCell(withVideo: video)
            cell.infoDidTap = { self.showAlerd(withDataInfo: $0) }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: SectionHeaderView.reuseIdentifier,
                                                                     for: indexPath) as! SectionHeaderView
        header.setTitle("Media files")
        return header
    }
}

//MARK: CollectionDelegate
extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectIndex(indexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        guard position > 30 else { return }
        if position > (collectionView.contentSize.height - 100 - scrollView.bounds.height) {
            loadingView.startAnimation()
            presenter.loadMoreData() { [weak self] in
                self?.loadingView.stopAnimation()
            }
        }
    }
    
}

