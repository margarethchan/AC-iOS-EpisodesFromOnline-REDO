//
//  DetailViewController.swift
//  AC-iOS-EpisodesFromOnline-REDO
//
//  Created by C4Q on 12/7/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    @IBOutlet weak var episodeNumberLabel: UILabel!
    
    @IBOutlet weak var episodeDescriptionTextView: UITextView!
    
    
    
    
    
    var selectedEpisode: Episode!

    override func viewDidLoad() {
        super.viewDidLoad()
        episodeTitleLabel.text = selectedEpisode?.name
        episodeNumberLabel.text = "Season: \(selectedEpisode.season!), Episode: \(selectedEpisode.number!)"
        episodeDescriptionTextView.text = selectedEpisode?.summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        episodeImageView.image = nil
        
        guard let imageURL = selectedEpisode.image?.original else {
            episodeImageView.image = #imageLiteral(resourceName: "No_Image_Available")
            return
        }
        
        let completion: (UIImage) -> Void = {(onlineImage: UIImage) in
            self.episodeImageView.image = onlineImage
        }
        ImageAPIClient.manager.getImage(from: imageURL, completionHandler: completion, errorHandler: {print($0)})
        
        
        
    }

}
