//
//  NewPostViewController.swift
//  Together
//
//  Created by lcx on 2021/11/6.
//

import UIKit
import MapKit

class NewPostViewController: UIViewController {
    @IBOutlet weak var postTitle: TextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var maxParticipants: UILabel!
    @IBOutlet weak var descriptions: TextView!
    @IBOutlet weak var departurePlace: TextView!
    @IBOutlet weak var destination: TextView!
    @IBOutlet weak var VStackView: UIStackView!
    @IBOutlet weak var test: UITableView!
    
    var post: Post!
    private let table = UITableView()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
//    private var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.placeHolder = "Title"
        descriptions.placeHolder = "Description"
        departurePlace.placeHolder = "Choose a departure place"
        destination.placeHolder = "Choose a destination"
        
        if post == nil {
            post = Post()
        }
        
        searchCompleter.delegate = self
//        let searchResultController = UITableViewController()
//        searchResultController.tableView = table
        table.delegate = self
        table.dataSource = self
        test.dataSource = self
        test.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
//        searchController = UISearchController(searchResultsController: searchResultController)
//        searchController.searchResultsUpdater = self
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.identifier)
        table.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        table.heightAnchor.constraint(equalToConstant: 200).isActive = true
        table.isHidden = true
        
        test.isHidden = true
//        if let index = VStackView.arrangedSubviews.firstIndex(of: destination) {
//            self.VStackView.insertArrangedSubview(self.table, at: index + 1)
//        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func minusButtonPressed(_ sender: Any) {
        let num = maxParticipants.toInt() - 1
        if num == 2 {
            minus.isEnabled = false
        }
        maxParticipants.text = "\(num)"
        plus.isEnabled = true
    }
    
    @IBAction func plusButtonPressed(_ sender: Any) {
        let num = maxParticipants.toInt() + 1
        if num == 20 {
            plus.isEnabled = false
        }
        maxParticipants.text = "\(num)"
        minus.isEnabled = true
    }
}

extension NewPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.isShowingPlaceHolder() {
            view.hidePlaceHolder()
        }
        if view == destination {
//            if let index = VStackView.arrangedSubviews.firstIndex(of: view) {
//                UIView.animate(withDuration: 0.5) {
//                    self.test.isHidden = !self.test.isHidden
//                }
//            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.endEditingWithEmpty() {
            view.showPlaceHolder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        searchCompleter.queryFragment = textView.text
    }
}

extension UILabel {
    func toInt() -> Int {
        guard let text = self.text,
              let num = Int(text)
        else {
            return 0
        }
        return num
    }
}

extension NewPostViewController: UITableViewDelegate {
//    tableview
}

extension NewPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

// Learned from https://dev.to/jeff_codes/swift-5-location-search-with-auto-complete-location-suggestions-20a1
//extension NewPostViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        searchCompleter.queryFragment = searchController.searchBar.text!
//    }
//}

extension NewPostViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
//        table.reloadData()
        test.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.test.isHidden = false
        }
    }
}
