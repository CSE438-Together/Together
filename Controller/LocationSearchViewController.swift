//
//  LocationSearchViewController.swift
//  Together
//
//  Created by lcx on 2021/11/7.
//

import UIKit

class LocationSearchViewController: UIViewController {
    @IBOutlet weak var address: UILabel!
    weak var delegate: NewPostViewController!
    var currentAddress: String!
    var addressLine1: String?
    
    private let searchResultsController = SearchResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        address.text = currentAddress
        searchResultsController.delegate = self
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
//        delegate.updateAddress(title, addressLine1, address.text)
        self.dismiss(animated: true)
    }
}

extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        // Learned from https://dev.to/jeff_codes/swift-5-location-search-with-auto-complete-location-suggestions-20a1
        searchResultsController.searchCompleter.queryFragment = text
    }
}
