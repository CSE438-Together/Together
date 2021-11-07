//
//  LocationSearchViewController.swift
//  Together
//
//  Created by lcx on 2021/11/7.
//

import UIKit

class LocationSearchViewController: UIViewController {
    private let searchController = UISearchController(searchResultsController: SearchResultsController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

}

extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              let table = searchController.searchResultsController as? SearchResultsController
        else {
            return
        }
        // Learned from https://dev.to/jeff_codes/swift-5-location-search-with-auto-complete-location-suggestions-20a1
        table.searchCompleter.queryFragment = text
    }
}
