
//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Sriram Hariharan on 9/4/18.
//  Copyright © 2018 Sriram Hariharan. All rights reserved.
//

import UIKit
import AlamofireImage
class NowPlayingViewController: UIViewController, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
// https://image.tmdb.org/t/p/w500
    
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 200
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        tableView.dataSource = self
        fetchMovies()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMovies()
    }
    
    func fetchMovies(){
        activityMonitor.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=aae0e36d928f642b3e2aed52c84ee908")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request){ (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityMonitor.stopAnimating()
            }
            // This will run when the Network request returns
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.cyan
        cell.selectedBackgroundView = backgroundView
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let placeholderString = "https://via.placeholder.com/275x350"
        let placeHolderURL = URL(string: placeholderString)!
        cell.posterImageView.af_setImage(withURL: placeHolderURL)
        if let posterPathString = movie["poster_path"] as? String{
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseURLString+posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
 
