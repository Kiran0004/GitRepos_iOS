//
//  RepoTableViewCell.swift
//  Github Top 30
//
//  Created by Kiran Kumar on 16/11/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import Foundation
import UIKit

public class RepoTableViewCell: UITableViewCell {
    @IBOutlet weak var repoNameLabel: UILabel?
    @IBOutlet weak var repoDescriptionLabel: UILabel?
    @IBOutlet weak var repoOwnerNameLabel: UILabel?
    @IBOutlet weak var repoAvatarImageView: UIImageView?
    @IBOutlet weak var stargazeCountLabel: UILabel?
    
    public override func prepareForReuse() {
        repoNameLabel?.text = nil
        repoDescriptionLabel?.text = nil
        repoOwnerNameLabel?.text = nil
        repoAvatarImageView?.image = nil
        stargazeCountLabel?.text = nil
    }
    
    func update(object: RepoModel, indexPath: IndexPath) {
        repoNameLabel?.text = object.repoName
        repoDescriptionLabel?.text = object.repoDescription
        repoOwnerNameLabel?.text = object.repoOwnerName
        
        stargazeCountLabel?.text = object.stargazersCount
    }
}
