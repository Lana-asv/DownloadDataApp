//
//  Presenter.swift
//  DownloadDataApp
//
//  Created by Sveta on 10.12.2021.
//

import Foundation

final class Presenter {
    private let model = Model()
    private weak var viewController: ViewControllerTables?
    
    init() {
        model.delegate = self
    }
    
    func loadView(_ controller: ViewControllerTables) {
        self.viewController = controller
        controller.delegate = self
    }
    
    func didEnterDowloadURL(_ downloadURL: URL) {
        self.model.downloadImage(url: downloadURL)
    }
}

extension Presenter: ViewControllerDelegate {
    func viewControllerNumberOfItems(_ viewController: ViewControllerTables) -> Int {
        return self.model.itemsCount()
    }
    
    func viewController(_ viewController: ViewControllerTables, itemAtIndex index: Int) -> DownloadItem {
        return self.model.itemAtIndex(index)
    }
}

extension Presenter: IModelDelegate {
    func modelDidUpdateItems(_ model: IModel) {
        self.viewController?.reloadData()
    }
    
    func model(_ model: IModel, didFailWithError error: String) {
        self.viewController?.updateWithError(error)
    }

    func modelDidUpdateProgress(_ model: IModel, forItemAt index: Int, progress: Float) {
        self.viewController?.updateProgress(index, progress: progress)
    }
}
