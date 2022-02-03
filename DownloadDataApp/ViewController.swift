//
//  ViewController.swift
//  DownloadDataApp
//
//  Created by Sveta on 09.12.2021.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func viewControllerNumberOfItems(_ viewController: ViewControllerTables) -> Int
    func viewController(_ viewController: ViewControllerTables, itemAtIndex index: Int) -> DownloadItem
}

final class ViewControllerTables: UIViewController {
    private let presenter: Presenter
    weak var delegate: ViewControllerDelegate?

    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 300
        tableView.register(DownloadTableViewCell.self, forCellReuseIdentifier: DownloadTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    init(presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBarSetup()
        self.presenter.loadView(self)
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func updateProgress(_ itemIndex: Int, progress: Float) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: itemIndex, section: 0)) as? DownloadTableViewCell
        cell?.updateProgress(progress)
    }

    func updateWithError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: "Введен неверный URL", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak alert] action in
            alert?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewControllerTables: UISearchBarDelegate {
    
    private func searchBarSetup() {
        self.searchController.searchBar.placeholder = "Введите URL для загрузки картинки"
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        self.searchController.searchBar.delegate = self
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("SEARCH TEXT \(searchBar.text)")
        
        guard let urlString = searchBar.text else {
            print("This is an invalid URL")
            return
        }

        guard let url = URL(string: urlString) else {
            print("This is an invalid URL")
            return
        }
        
        self.presenter.didEnterDowloadURL(url)
        searchController.dismiss(animated: false, completion: nil)
    }
}

extension ViewControllerTables: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.delegate?.viewControllerNumberOfItems(self) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTableViewCell.identifier, for: indexPath) as! DownloadTableViewCell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero

        let item = self.delegate?.viewController(self, itemAtIndex: indexPath.row)
        cell.updateImage(item?.image)
        return cell
    }
}
