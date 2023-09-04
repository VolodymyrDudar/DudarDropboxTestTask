//
//  Video.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import UIKit

struct Video: Hashable  {
    var videoUrl: URL?
    var infoFromWeb: FileInfo?
    
    var infoFromLocalUrt: FileInfo? {
        if let videoUrl {
           return FileInfo.init(fromUrl: videoUrl)
        }else {
            return nil
        }
    }
}
