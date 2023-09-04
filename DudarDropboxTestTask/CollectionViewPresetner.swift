//
//  ViewControllerPresetner.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 01.09.2023.
//

import UIKit
import SwiftyDropbox
import AVKit
 
protocol CollectionViewPresetner: AnyObject { 
    func setCollection(withMediaFiles files: [Item])
    func present(viewController: UIViewController)
}

protocol CollectionViewPresetnerOut {
    var view: CollectionViewPresetner? { get set }
    func viewDidAppear()
    func didSelectIndex(indexPath: IndexPath)
    func logoutButtonTapped(completion: (Result<Bool, Error>) -> Void)
    func loadMoreData(noMoreData: () -> Void)
}


class CollectionViewPresetnerImpl {
    
    public weak var view: CollectionViewPresetner?
    private let client = DropboxClientsManager.authorizedClient
    private let fileManager = FileManager.default
    private var directoryURL: URL {fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]}
    private var isPaginating = false
    private var page = 0
    
    private var listFileNameOfMediaFomDropBox = [Int: [MediaFileInfo]]() {
        didSet {
            if page == 0 {
                loadDataForPage(page: page, filesInfo: listFileNameOfMediaFomDropBox){}
            }
        }
    }
    private var items = [Item]() {
        didSet{ view?.setCollection(withMediaFiles: items) }
    }
 
    //MARK: fetch data
    private func loadListFilesFromDropbox() {
        let dispGroup = DispatchGroup()
        let queue = DispatchQueue(label: "st",qos: .utility)
        var tempMediaNamesArra = [MediaFileInfo]()
        dispGroup.enter()
        self.client?.files.listFolder(path: "").response(queue: queue) { response, error in
            guard let response else { return }
            response.entries.forEach { file in
                if file.name.hasSuffix(".jpg") || file.name.hasSuffix(".png") || file.name.hasSuffix(".jpeg") {
                    tempMediaNamesArra.append(MediaFileInfo(nameOnServer: file.name, typeMedia: .images))
                }
                if file.name.hasSuffix(".mp4") {
                    tempMediaNamesArra.append(MediaFileInfo(nameOnServer: file.name, typeMedia: .videos))
                }
            }
            dispGroup.leave()
        }
        dispGroup.notify(queue: queue) { [weak self] in
            guard let self else { return }
            self.listFileNameOfMediaFomDropBox = self.splitArrayIntoChunks(fromArray: tempMediaNamesArra)
        }
    }
       
    func splitArrayIntoChunks(ofSize chunkSize: Int = 12, fromArray array: [MediaFileInfo]) -> [Int: [MediaFileInfo]] {
        var resultDictionary = [Int: [MediaFileInfo]]()
        for (index, element) in array.enumerated() {
            let chunkIndex = index / chunkSize
            if resultDictionary[chunkIndex] == nil {
                resultDictionary[chunkIndex] = [MediaFileInfo]()
            }
            resultDictionary[chunkIndex]?.append(element)
        }
        return resultDictionary
    }
     
    private func loadDataForPage(page: Int, filesInfo: [Int: [MediaFileInfo]], fail: () -> Void)  {
        isPaginating = true
        guard let media = filesInfo[page] else {
           isPaginating = false
            fail()
            return
        }
        fillDataArrays(infoFiles: media) { [weak self] items in
            self?.items.append(contentsOf: items)
            self?.page += 1
            self?.isPaginating = false
        }
    }
     
    private func fillDataArrays(infoFiles: [MediaFileInfo], compl: @escaping ([Item]) -> Void ) {
        let dispGroup = DispatchGroup()
        let queue = DispatchQueue(label: "med", qos: .utility)
        var tempArray = [Item]()
        infoFiles.forEach { file in
            dispGroup.enter()
            let destURL = directoryURL.appendingPathComponent(file.nameOnServer)
            do {
               let data = try Data(contentsOf: destURL)
                switch file.typeMedia {
                case .images:
                    tempArray.append(.image(Image(data: data, info: FileInfo(fromUrl: destURL))))
                case .videos:
                    tempArray.append(.videoUrl(Video(videoUrl: destURL)))
                }
                print("FileExist====--------")
                dispGroup.leave()
            }catch {
                client?.files.download(path: "/\(file.nameOnServer)").response(queue: queue) { result, err in
                    if let (meta, data) = result {
                        try? data.write(to: destURL)
                        switch file.typeMedia {
                        case .images:
                            tempArray.append(.image(Image(data: data,info: FileInfo(fromFileMetaData: meta))))
                        case .videos:
                            tempArray.append(.videoUrl(Video(videoUrl: destURL, infoFromWeb: FileInfo(fromFileMetaData: meta))))
                        }
                        dispGroup.leave()
                    } else if let err {
                        print(err.description)
                    }
                }
            }
        }
        dispGroup.notify(queue: .main) {
            compl(tempArray)
        }
    }
  
}

//MARK: Actions
extension CollectionViewPresetnerImpl: CollectionViewPresetnerOut {
    
    func loadMoreData(noMoreData: () -> Void ) {
        guard !isPaginating else { return }
        loadDataForPage(page: page, filesInfo: listFileNameOfMediaFomDropBox, fail: noMoreData)
    }
     
    func didSelectIndex(indexPath: IndexPath) {
        switch items[indexPath.row] {
        case .image(_):
            let images = items.map { $0.image }
            view?.present(viewController: PageViewController(
                presenter: PageViewPresenterImpl(dataArray: images, selectedIndex: indexPath.row))
            )
        case .videoUrl(_):
            guard let videoURL = items[indexPath.row].videoUrl?.videoUrl else { return }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.modalPresentationStyle = .fullScreen
            playerViewController.player = player
            view?.present(viewController: playerViewController)
        }
    }
     
    func viewDidAppear() {
        loadListFilesFromDropbox()
    }
      
    func logoutButtonTapped(completion: (Result<Bool, Error>) -> Void) {
        print(#function)
        do{
            try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles).forEach { url in
                try fileManager.removeItem(at: url)
                print("Deleted file: \(url)")
            }
            DropboxClientsManager.unlinkClients()
        }catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
}
