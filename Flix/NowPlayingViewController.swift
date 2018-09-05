//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Sriram Hariharan on 9/4/18.
//  Copyright © 2018 Sriram Hariharan. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=aae0e36d928f642b3e2aed52c84ee908")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request){ (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data{
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                for movie in movies{
                    let title = movie["title"] as! String
                    print(title)
                }
            }
            // This will run when the Network request returns
        }
        task.resume()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
 
