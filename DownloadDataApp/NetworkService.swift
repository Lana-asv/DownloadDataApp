//
//  Network.swift
//  DownloadDataApp
//
//  Created by Sveta on 09.12.2021.
//

import Foundation
import UIKit

protocol NetworkServiceDelegate: AnyObject {
    func networkService(_ service: NetworkService, url: URL, didFinishDownloading item: DownloadItem?)
    func networkService(_ service: NetworkService, url: URL, didFailWithError error: Error)
    func networkService(_ service: NetworkService, url: URL, progress: Float)
}

final class NetworkService: NSObject {
    lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    weak var delegate: NetworkServiceDelegate?

    func downloadImage(url: URL) {
        let downloadTask = self.session.downloadTask(with: url)
        downloadTask.resume()
    }
}

extension NetworkService: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let err = error else {
            return
        }
        
        guard let originalURL = task.originalRequest?.url else {
            return
        }

        DispatchQueue.main.async {
            self.delegate?.networkService(self, url: originalURL, didFailWithError: err)
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let originalURL = downloadTask.originalRequest?.url else {
            return
        }

        guard let data = try? Data(contentsOf: location) else {
            print("The data could not be loaded")
            return
        }

        let image = UIImage(data: data)
        DispatchQueue.main.async {
            let item = DownloadItem(image: image)
            self.delegate?.networkService(self, url: originalURL, didFinishDownloading: item)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let originalURL = downloadTask.originalRequest?.url else {
            return
        }

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.delegate?.networkService(self, url: originalURL, progress: progress)
        }
    }
}
