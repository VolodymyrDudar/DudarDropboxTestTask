//
//  String + extension.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 04.09.2023.
//

import Foundation

extension String {
    func isVideoFile() -> Bool {
        let supportedExtensions = [ "mp4","mov","avi","mkv","wmv","flv","webm","m4v","3gp","ts","m2ts","vob","mpg","mpeg","divx","xvid","rm","rmvb","ogv", "mts" ] 
        let fileExtension = (self as NSString).pathExtension.lowercased()
        return supportedExtensions.contains(fileExtension)
    }
    
    func isImageFile() -> Bool {
        let supportedExtensions = ["png", "jpg", "jpeg", "gif", "bmp", "tiff", "ico", "icns" ] 
        let fileExtension = (self as NSString).pathExtension.lowercased()
        return supportedExtensions.contains(fileExtension)
    }
     
}
