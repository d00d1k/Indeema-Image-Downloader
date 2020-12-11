//
//  DownloadManager.swift
//  iuiui
//
//  Created by Nikita Kalyuzhnyy on 11.12.2020.
//

import Foundation

class DownloadManager {
    
    var url : String
    var isDownloading = false
    var downloadProgresss : Float = 0.0
    
    var downloadTask : URLSessionDownloadTask?
    var resumeData : Data?
    
    init(url: String) {
        self.url = url
    }

}
