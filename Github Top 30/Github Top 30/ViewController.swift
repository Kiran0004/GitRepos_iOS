//
//  ViewController.swift
//  Github Top 30
//
//  Created by Kiran Kumar on 16/11/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var repoObjects = [RepoModel]()
    var isLoading = false
    var retryCount = 0
    var hasMoreRepos = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchNextPage()
    }
    
    func fetchNextPage() {
        if isLoading {
            return
        }
        isLoading = true
        NetworkHelper.shared().fetchRepoDataWith(nil) { (json, error) in
            self.isLoading = false
            if error != nil {
                print(error.debugDescription)
            } else if let repoArray = json?["items"] as? [[String: Any]] {
                self.addRepoObjects(repoArray: repoArray)
            } else {
                //Download error
                DispatchQueue.main.async {
                    self.retry()
                }
            }
        }
    }
    
    func addRepoObjects(repoArray: [[String: Any]]) {
        var indexPaths = [IndexPath]()
        for repoDict in repoArray {
            let repoObject = RepoModel.init(dict: repoDict)
            indexPaths.append(IndexPath(row: repoObjects.count, section: 0))
            repoObjects.append(repoObject)
        }
        
        DispatchQueue.main.async {
            guard let table = self.tableView else {
                return
            }
            
            table.beginUpdates()
            table.insertRows(at: indexPaths, with: .automatic)
            //Assuming 30 objects are coming at a time and that wont change
            if indexPaths.count < 30 {
                self.hasMoreRepos = false
                table.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            }
            table.endUpdates()
        }
    }
    
    func retry() {
        if retryCount < 4 {
            if let section = tableView.indexPathsForVisibleRows?.last?.section,
                section == 1 {
                fetchNextPage()
                self.retryCount += 1
            }
        } else {
            hasMoreRepos = false
            tableView.deleteSections(IndexSet(arrayLiteral: 1), with: .automatic)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if hasMoreRepos {
            return 2
        }
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return repoObjects.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCell") as? ActivityIndicatorCell else {
                return UITableViewCell()
            }
            cell.activityIndicator?.startAnimating()
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? RepoTableViewCell else {
            return UITableViewCell()
        }
        update(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func update(cell: RepoTableViewCell, indexPath: IndexPath) {
        let object = repoObjects[indexPath.row]
        cell.update(object: object, indexPath: indexPath)
        if let avatarURL = object.repoAvatarURL {
            ImageDownloadHelper.shared().loadImage(imageURL: avatarURL, indexPath: indexPath, completionHandler: { (image, error) in
                guard let downloadedImage = image else {
                     return
                }
                DispatchQueue.main.async {
                    if let indexPathsVisible = self.tableView.indexPathsForVisibleRows,
                        indexPathsVisible.contains(indexPath) {
                        cell.repoAvatarImageView?.image = downloadedImage
                    }
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        retryCount = 0
        fetchNextPage()
    }
}

