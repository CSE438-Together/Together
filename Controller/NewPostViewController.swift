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
    @IBOutlet weak var destinationAutocomplete: UITableView!
    @IBOutlet weak var departurePlaceAutocomplete: UITableView!
    
    var post: Post!
    private var currentTextView: TextView?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.placeholder = "Title"
        descriptions.placeholder = "Description"
        departurePlace.placeholder = "Choose a departure place"
        destination.placeholder = "Choose a destination"
        departurePlace.autocompleteTable = departurePlaceAutocomplete
        destination.autocompleteTable = destinationAutocomplete
        
        let inset = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        destinationAutocomplete.contentInset = inset
        departurePlaceAutocomplete.contentInset = inset
        
        if post == nil {
            post = Post()
        }
        // Learned from https://dev.to/jeff_codes/swift-5-location-search-with-auto-complete-location-suggestions-20a1
        searchCompleter.delegate = self
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
        if view.isShowingPlaceholder() {
            view.hidePlaceholder()
        }
        currentTextView = view
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.isEmpty() {
            view.showPlaceholder()
        }
        view.removeAutocompleteTable()
        currentTextView = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == destination || textView == departurePlace {
            searchCompleter.queryFragment = textView.text
        }
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = searchResults[indexPath.row].title + "\n" + searchResults[indexPath.row].subtitle
        if tableView == departurePlaceAutocomplete {
            autocompleteSelected(departurePlace, text)
        } else if tableView == destinationAutocomplete {
            autocompleteSelected(destination, text)
        }
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(text) { (placemarks, error) in
//            guard let placemark = placemarks?.first else { return }
//            let item = MKMapItem(placemark: MKPlacemark(placemark: placemark))
//            item.openInMaps(launchOptions: nil)
//        }
    }
    
    private func autocompleteSelected(_ textView: TextView, _ text: String) {
        textView.text = text
        textView.removeAutocompleteTable()
    }
}

extension NewPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "autocompleteCell",
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

extension NewPostViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        
        guard let textView = currentTextView else { return }
        textView.loadSearchResults()
    }
}
