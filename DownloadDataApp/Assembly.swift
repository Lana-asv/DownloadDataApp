//
//  Assembly.swift
//  DownloadDataApp
//
//  Created by Sveta on 15.12.2021.
//

import UIKit

final class Assembly {
    static func buildViewController() -> UIViewController {
        let presenter = Presenter()
        let viewController = ViewControllerTables(presenter: presenter)
        return viewController
    }
}
