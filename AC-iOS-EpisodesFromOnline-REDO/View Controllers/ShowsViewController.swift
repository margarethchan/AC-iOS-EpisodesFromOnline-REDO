//
//  ShowsViewController.swift
//  AC-iOS-EpisodesFromOnline-REDO
//
//  Created by C4Q on 12/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var shows = [ShowInfo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchTerm = "" {
        didSet {
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
        loadData()
        tableView.reloadData()
    }
    
    
    func loadData() {
        let url = "http://api.tvmaze.com/search/shows?q=\(searchTerm)"
        ShowAPIClient.manager.getShows(from: url, completionHandler: {self.shows = $0}, errorHandler: {print($0)})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EpisodesViewController {
            let showID = shows[(tableView.indexPathForSelectedRow?.row)!].show.id
            destination.episodeURL = "http://api.tvmaze.com/shows/\(String(describing: showID))/episodes"
        }
        
    }
    
}

extension ShowsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = (searchBar.text?.components(separatedBy: " ").joined(separator: "%20"))!
        searchBar.resignFirstResponder()
    }
    
}


extension ShowsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = shows[indexPath.row]
        guard let showCell = tableView.dequeueReusableCell(withIdentifier: "Show Cell", for: indexPath) as? CustomShowCell else { return UITableViewCell() }
        showCell.showNameLabel.text = show.show.name
        showCell.showImageView.image = nil
        guard let rating = (show.show.rating.average) else {
            showCell.showRatingLabel.text = "No rating"
            return showCell
            
        }
        showCell.showRatingLabel?.text = "Rated: \(rating)"
        guard let imageUrlStr = show.show.image?.original else { return showCell }
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            showCell.showImageView.image = onlineImage
            showCell.setNeedsLayout()
        }
        ImageAPIClient.manager.getImage(from: imageUrlStr, completionHandler: completion, errorHandler: {print($0)})
        return showCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
}
