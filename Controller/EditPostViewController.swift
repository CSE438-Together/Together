//
//  EditPostViewController.swift
//  Together
//
//  Created by Bingxin Liu on 11/12/21.
//

// This VC should not exist
// should merge into NewPostVC
// for safety reason just duplicate most part


import UIKit
import MapKit
import Amplify

class EditPostViewController: UIViewController {
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
    @IBOutlet weak var departurePlaceEdit: UIButton!
    @IBOutlet weak var destinationEdit: UIButton!
    @IBOutlet weak var transportation: UISegmentedControl!
    
    // remove private
    var post: Post?
    // what is this ???
    //private let delegate: ExploreViewController
    private var currentTextView: TextView?
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults = [MKLocalSearchCompletion]()
  
    // whats is this ???
//    init?(coder: NSCoder, delegate: ExploreViewController) {
//        self.delegate = delegate
//        super.init(coder: coder)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTitle.placeholder = "Title"
        descriptions.placeholder = "Description"
        departurePlace.placeholder = "Choose a departure place"
        destination.placeholder = "Choose a destination"
        departurePlace.autocompleteTable = departurePlaceAutocomplete
        destination.autocompleteTable = destinationAutocomplete
        departurePlace.editButton = departurePlaceEdit
        destination.editButton = destinationEdit
        
        datePicker.minimumDate = datePicker.date
        
        // Learned from https://dev.to/jeff_codes/swift-5-location-search-with-auto-complete-location-suggestions-20a1
        searchCompleter.delegate = self
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let item = Post(
            title: postTitle.text,
            departurePlace: departurePlace.text,
            destination: destination.text,
            //lbx: tmp change set it always with car
            //transportation: Transportation.getInstance(of: transportation.selectedSegmentIndex),
            //to:
            transportation: Transportation.init(rawValue: "CAR"),
            departureTime: Temporal.DateTime(datePicker.date),
            maxMembers: maxParticipants.toInt(),
            description: descriptions.text
        )
        Amplify.DataStore.save(item) {
            result in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.id)")
            case .failure(let error):
                print("Could not save item to DataStore: \(error)")
            }
        }
        // delete
//        self.dismiss(animated: true) {
//            self.delegate.posts.insert(item, at: 0)
//        }
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
    
    @IBAction func departurePlaceEditButtonPressed(_ sender: UIButton) {
        handleEditButton(sender, departurePlace)
    }
    
    @IBAction func destinationEditButtonPressed(_ sender: UIButton) {
        handleEditButton(sender, destination)
    }
    
    private func handleEditButton(_ button: UIButton, _ textView: TextView) {
        textView.isEditable = true
        textView.selectAll(self)
        UIView.animate(withDuration: 0.5) {
            button.isHidden = true
        }
    }
}

extension EditPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if view.isShowingPlaceholder() {
            view.hidePlaceholder()
        }
        currentTextView = view
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let view = textView as? TextView else { return }
        if !view.hasText {
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

extension EditPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = searchResults[indexPath.row].title + "\n" + searchResults[indexPath.row].subtitle
        if tableView == departurePlaceAutocomplete {
            autocompleteSelected(departurePlace, text)
        } else if tableView == destinationAutocomplete {
            autocompleteSelected(destination, text)
        }
    }
    
    private func autocompleteSelected(_ textView: TextView, _ text: String) {
        UIView.animate(withDuration: 0.5) {
            textView.text = text
        }
        textView.endEditing(true)
    }
}

extension EditPostViewController: UITableViewDataSource {
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

extension EditPostViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        guard let textView = currentTextView else { return }
        textView.loadSearchResults()
    }
}
