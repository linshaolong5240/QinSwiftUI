//
//  URL+Extension.swift
//  Qin
//
//  Created by teenloong on 2021/7/11.
//

import Foundation

extension URL {
    var fileName: String? {
        guard isFileURL else {
            return nil
        }
        
        return lastPathComponent
    }
    var fileNameWithoutExtension: String? {
        guard isFileURL else {
            return nil
        }
        
        return deletingPathExtension().lastPathComponent
    }
    var fileSize: Int? {
        try? resourceValues(forKeys: [.fileSizeKey]).fileSize
    }
}
