//
//  ViewModel.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 01.09.2023.
//

import UIKit
 


enum Item: Hashable {
    case image(Image)
    case videoUrl(Video)
    
    var image: Image? {
        if case .image(let image) = self {
            return image
        }else{
            return nil
        }
    }
    var videoUrl: Video? {
        if case .videoUrl(let url) = self {
            return url
        }else{
            return nil
        }
    }
}


