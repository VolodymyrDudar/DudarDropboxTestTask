//
//  FileInfo.swift
//  DudarDropboxTestTask
//
//  Created by Volodymyr D on 02.09.2023.
//

import Foundation
import SwiftyDropbox

struct FileInfo: Codable , Hashable {
   var mediaInfo: Info?
    var name: String?
    var serverModified: String?
    private var clientModified: Date? 
    private  var size: UInt64?
    
    var modified: String? { self.clientModified?.strFormatDate()  }
    var sizeString: String {
        let fileSizeInBytes = Double(size ?? 0)
        let byteFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = [.useKB, .useMB]
        byteFormatter.countStyle = .file
        return byteFormatter.string(fromByteCount: Int64(fileSizeInBytes))
    }
    
    init(fromFileMetaData metaData: Files.FileMetadata)  {
        self.clientModified = metaData.clientModified
        self.name = metaData.name
        self.serverModified = metaData.serverModified.strFormatDate()
        self.size = metaData.size
    }
    
    init?(fromUrl url: URL) {
        do {
            let fileManager = FileManager.default
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            self.name = URL(fileURLWithPath: url.path).lastPathComponent
            self.clientModified = attributes[.modificationDate] as? Date
            self.size = attributes[.size] as? UInt64
        } catch {
            print("Error retrieving file metadata: \(error.localizedDescription)")
            return nil
        }
    }
    
}

struct Info: Codable, Hashable {
    let tag: String?
    let metadata: Metadata?
}

struct Metadata: Codable, Hashable {
    let tag: String?
    let dimensions: Dimensions?
}

struct Dimensions: Codable, Hashable {
    let height: Int?
    let width: Int?
}
