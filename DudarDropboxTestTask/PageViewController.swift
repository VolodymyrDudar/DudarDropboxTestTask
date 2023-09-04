//
//  PageViewController.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit

class PageViewController: UIPageViewController {
  
    private var pageViewControllers = [UIViewController]() 
    private var presenter: PagePresenterOut!
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       dataSource = self
        
       view.backgroundColor = .black
   }
    
    override func viewDidAppear(_ animated: Bool) {
       presenter.viewDidAppear()
    }
  
    init(presenter: PagePresenterOut = PageViewPresenterImpl()) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.presenter = presenter
        self.presenter.view = self
    }
    required init?(coder: NSCoder) { fatalError( )}
   
   private func selectPage(onIndex: Int) {
       currentIndex = onIndex
        if  self.pageViewControllers.count >= onIndex + 1 {
            self.setViewControllers([self.pageViewControllers[onIndex]],
                                    direction: .forward,
                                    animated: true)
        }
    }
    
}

extension PageViewController: PageViewPresenter {
  
    func setViewControllers(vcs: [UIViewController], selectedIndex: Int ) {
        pageViewControllers = vcs
        selectPage(onIndex: selectedIndex)
    }
     
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pageViewControllers.firstIndex(of: viewController),
           currentIndex > 0 {
            return pageViewControllers[currentIndex - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentIndex = pageViewControllers.firstIndex(of: viewController),
           currentIndex < pageViewControllers.count - 1 {
            return pageViewControllers[currentIndex + 1]
        }
        return nil
    }
     
    func presentationCount(for pageViewController: UIPageViewController) -> Int {  pageViewControllers.count }
     
    func presentationIndex(for pageViewController: UIPageViewController) -> Int { currentIndex }
    
    
      
}

 
