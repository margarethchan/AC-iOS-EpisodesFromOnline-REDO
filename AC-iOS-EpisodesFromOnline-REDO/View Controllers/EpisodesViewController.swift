//
//  EpisodesViewController.swift
//  AC-iOS-EpisodesFromOnline-REDO
//
//  Created by C4Q on 12/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet weak var episodeTableView: UITableView!
    
    var showID: Int?
    
    var episodes = [Episode]() {
        didSet {
            episodeTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.episodeTableView.dataSource = self
        self.episodeTableView.delegate = self
        loadEpisodes()
    }
    
    func loadEpisodes() {
        let episodeURL = "http://api.tvmaze.com/shows/\(showID!)/episodes"
        let completion: ([Episode]) -> Void = {(onlineEpisodes: [Episode]) in
            self.episodes = onlineEpisodes
        }
        EpisodeAPIClient.manager.getEpisodes(from: episodeURL, completionHandler: completion, errorHandler: {print($0)})
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.selectedEpisode = episodes[(self.episodeTableView.indexPathForSelectedRow!.row)]
        }
    }
    
    
    
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episodeCell = self.episodeTableView.dequeueReusableCell(withIdentifier: "Episode Cell", for: indexPath) as! CustomEpisodeCell
        let episode = episodes[indexPath.row]
        episodeCell.episodeNameLabel.text = episode.name
        let season = episode.season?.description ?? "N/A"
        let number = episode.number?.description ?? "N/A"
        episodeCell.episodeNumberLabel.text = "S: \(season) E: \(number)"
        episodeCell.episodeImageView.image = nil
        
        guard let imageURL = episode.image?.medium else {
            episodeCell.episodeImageView.image = #imageLiteral(resourceName: "No_Image_Available")
            episodeCell.setNeedsLayout()
            return episodeCell
        }
        
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            episodeCell.episodeImageView.image = onlineImage
            episodeCell.setNeedsLayout()
        }
        ImageAPIClient.manager.getImage(from: imageURL, completionHandler: completion, errorHandler: {print($0)})
        return episodeCell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    
    
}
