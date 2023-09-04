//
//  MediaFileInfo.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 04.09.2023.
//

import Foundation


struct MediaFileInfo {
    var nameOnServer: String
    var typeMedia: TypeMedia    
}

enum TypeMedia {
    case images
    case videos
}
