//
//  Image.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit

struct Image: Hashable  {
    var image: UIImage?
    var info: FileInfo?
    
    init(image: UIImage? = nil, info: FileInfo? = nil) {
        self.image = image
        self.info = info
    }
    init(data: Data? = nil, info: FileInfo? = nil) {
        guard let data, let image = UIImage(data: data) else { return }
        self.image = image
        self.info = info
    }
}
