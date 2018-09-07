//
//  YoutubeViewController.swift
//  youtubeTest
//
//  Created by Lai Evan on 9/27/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import UIKit
import YoutubeSourceParserKit
import AVFoundation

class YoutubeViewController: UIViewController {
    
    var urlString: String!
    
    var avPlayer: AVPlayer!
    
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
    
        let url = URL(string: self.urlString)

        let request = URLRequest(url: url!)

        self.webView.loadRequest(request)
        
        let urlString = "https://www.youtube.com/embed/qf09H2xFq2s"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
