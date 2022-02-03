//
//  Model.swift
//  DownloadDataApp
//
//  Created by Sveta on 10.12.2021.
//

import Foundation

protocol IModel {
    func downloadImage(url: URL)
    func itemsCount() -> Int
    func itemAtIndex(_ index: Int) -> DownloadItem
}

protocol IModelDelegate: AnyObject {
    func modelDidUpdateItems(_ model: IModel)
    func model(_ model: IModel, didFailWithError error: String)
    func modelDidUpdateProgress(_ model: IModel, forItemAt index: Int, progress: Float)
}

final class Model: IModel {
    private let networkService = NetworkService()
    private var items: [URL: DownloadItem] = [:]
    private var itemsKeys: [URL] = []
    
    weak var delegate: IModelDelegate?

    init() {
        self.networkService.delegate = self
    }
    
    func downloadImage(url: URL) {
        self.itemsKeys.append(url)
        self.delegate?.modelDidUpdateItems(self)

        if self.items[url] != nil {
            return
        }
        
        self.networkService.downloadImage(url: url)
    }

    func itemsCount() -> Int {
        return self.itemsKeys.count
    }
    
    func itemAtIndex(_ index: Int) -> DownloadItem {
        let url = self.itemsKeys[index]
        return self.items[url] ?? DownloadItem(image: nil)
    }
}

extension Model: NetworkServiceDelegate {
    func networkService(_ service: NetworkService, url: URL, didFailWithError error: Error) {
        print("ERROR originalURL \(url) \(error)")
        self.delegate?.model(self, didFailWithError: error.localizedDescription)

        guard let index = self.itemsKeys.lastIndex(of: url) else {
            return
        }

        self.itemsKeys.remove(at: index)
        self.delegate?.modelDidUpdateItems(self)
    }

    func networkService(_ service: NetworkService, url: URL, didFinishDownloading image: DownloadItem?) {
//        self.itemsKeys.append(url)
        self.items[url] = image
        self.delegate?.modelDidUpdateItems(self)
    }
    
    func networkService(_ service: NetworkService, url: URL, progress: Float) {
        guard let index = self.itemsKeys.lastIndex(of: url) else {
            return
        }

        self.delegate?.modelDidUpdateProgress(self, forItemAt: index, progress: progress)
    }
}


