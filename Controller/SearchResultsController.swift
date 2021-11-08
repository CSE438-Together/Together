//
//  SearchResultsController.swift
//  Together
//
//  Created by lcx on 2021/11/7.
//

import UIKit
import MapKit

class SearchResultsController: UITableViewController {
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    weak var delegate: LocationSearchViewController!
    
    override func viewDidLoad() {
//        searchCompleter.delegate = self
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationTableViewCell.identifier,
            for: indexPath
        )
        guard let title = cell.textLabel,
              let subtitle = cell.detailTextLabel
        else {
            return cell
        }
        title.text = searchResults[indexPath.row].title
        subtitle.text = searchResults[indexPath.row].subtitle
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        var title = searchResults[indexPath.row].title
//        let subtitle = searchResults[indexPath.row].subtitle
//        delegate.addressLine1 = title
//        title += "\n"
//        if subtitle != "Search Nearby" {
//            delegate.address.text = title + subtitle
//        } else {
//            delegate.address.text = title
//        }
//        self.dismiss(animated: true)
//    }
}
//
//extension SearchResultsController: MKLocalSearchCompleterDelegate {
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        searchResults = completer.results
//        tableView.reloadData()
//    }
//}
