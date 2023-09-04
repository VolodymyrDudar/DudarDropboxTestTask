//
//  ImageViewPresenter.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit


protocol ImageViewPresenter: AnyObject {
    func get(image: UIImage, dataInfo: FileInfo?)
}

protocol ImageViewPresenterOut {
    var view: ImageViewPresenter? { get set }
    func viewDidAppear()
}
 
class ImageViewPresenterImpl {
    
    weak var view: ImageViewPresenter?
    
    var data: Image?
    
    init(data: Image? = .none) {
        self.data = data
    }
    
}

extension ImageViewPresenterImpl: ImageViewPresenterOut {
    func viewDidAppear() {
        if let image = data?.image  {
            view?.get(image: image, dataInfo: data?.info)
        }else if let errImage = UIImage(named: "errorImage"){
            view?.get(image: errImage, dataInfo: nil)
        }
    }
    
}
