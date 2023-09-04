//
//  PageViewPresenter.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit


protocol PageViewPresenter: AnyObject {
    func setViewControllers(vcs: [UIViewController], selectedIndex: Int)
}

protocol PagePresenterOut {
    var view: PageViewPresenter? { get set }
    func viewDidAppear()
}


class PageViewPresenterImpl {
    weak var view: PageViewPresenter?
    private var selectedIndex = 0
    private var dataArray = [Image?]()
 
    init(dataArray: [Image?] = [], selectedIndex: Int = 0) {
        self.dataArray = dataArray
        self.selectedIndex = selectedIndex
    }
      
}
 
extension PageViewPresenterImpl: PagePresenterOut {
    func viewDidAppear() {
        let vcs = dataArray.reduce(into: [UIViewController]()) { partialResult, data in
            partialResult.append(ImageViewController(presenter: ImageViewPresenterImpl(data: data)))
        }
        view?.setViewControllers(vcs: vcs, selectedIndex: selectedIndex)
    }
}
