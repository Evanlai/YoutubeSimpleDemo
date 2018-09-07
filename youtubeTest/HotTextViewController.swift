//
//  HotTextViewController.swift
//  youtubeTest
//
//  Created by Lai Evan on 9/27/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import ObjectMapper
import YoutubeSourceParserKit
import AVFoundation
import AVKit
import ESPullToRefresh


class HotTextViewController: UITableViewController,UISearchBarDelegate{
    
    var youtubeItems = [YoutubeItem]()
    
    var youtubeInfo: YotubeInfo?
    
    var searchController: UISearchController?
    
    var refresher: UIRefreshControl?
    
    var urlString = ""
    
    var SearchString = ""
    
    var PrevPageToken = ""
    
    var NextPageToken = ""
    
    @IBOutlet weak var mytableview: UITableView!
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
  
    func loadData(){
        
        let url = "https://www.googleapis.com/youtube/v3/search"
        
        let parameters: Parameters = getUrlParameter(str: NextPageToken)

            // Alamofire 讀取 JSON 網址 資料
            Alamofire.request(url,parameters: parameters).responseJSON{ response in
            
            guard response.result.isSuccess else{
                
                _ = response.result.error?.localizedDescription
                
                return
                
            }
            
            guard let JSON = response.result.value as? [String:Any] else{
                
                return
                
            }
    
            // JSON資料帶入 YotubeInfo # ObjectMapper # 作解析
            self.youtubeInfo = YotubeInfo(JSON:JSON)
                
                
            // 取得上一頁下一頁資訊 # 目前沒有使用。
            if((self.youtubeInfo?.prevPageToken) != nil){
                
                self.PrevPageToken = (self.youtubeInfo?.prevPageToken)!
                    
            }
                
            self.NextPageToken = (self.youtubeInfo?.nextPageToken)!
            
            for item in self.youtubeInfo!.items!{
                    
                self.youtubeItems.append(item)
                    
            }
                
            self.mytableview.reloadData()
 
        }
    }
    
    // 此寫法是讓中文能夠正常顯示，若直接字串串接會有問題
    func getUrlParameter(str:String) -> Parameters{
        
        let parameters: Parameters = ["part": "snippet","maxResults":"5","q":SearchString,"type":"video","key":"AIzaSyDfgq-CbLXVX_ccXL8CfDh1LpaUk9ygcSU","pageToken":str]
        
        return parameters
        
    }
    
    //init UISearchBar
    func configureSearchController(){
        
        self.searchController = UISearchController(searchResultsController: nil)
  
        self.searchController?.dimsBackgroundDuringPresentation = false
        
        self.searchController?.searchBar.placeholder = "Search here..."
        
        self.searchController?.searchBar.delegate = self
        
        self.searchController?.searchBar.sizeToFit()
        
        self.searchController?.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.titleView = searchController?.searchBar
        
    }
    
    // 輸入文字時就開始搜尋
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // 若 text 為空，則return什麼都不作
        guard let str = self.searchController?.searchBar.text else { return }
        
        youtubeItems.removeAll()
        
        SearchString = str
    
        loadData()
     
    }
    
    

    // 設定 Sections 數量
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    // 設定Row的數量，依items的數量為count.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let items = youtubeItems.count as? Int else { return 0 }

        return items
        
    }
    
    // 設定Row Cell的內容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HotViewCell
        
        let item = youtubeItems[indexPath.row]
        
        // Get Url 數值
        let URLString = URL(string: item.snippet!.thumbnails!.defaultImage!.url!)
        
        // 將Url轉換成Data，供UIImage使用
        let data = try? Data(contentsOf: URLString!)
        
        cell.descLabel.text = item.snippet?.description
        
        cell.titleLabel.text = item.snippet?.title
        
        cell.thumbImageView.image = UIImage(data:data!)
        
        return cell
        
    }
    
    // 選擇Row時的動作
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let info  = self.youtubeInfo else { return }

        let item = youtubeItems[indexPath.row]
        
        let youtubeTitle = item.getID!.videoId!
        
        let url = URL(string: "https://www.youtube.com/watch?v=\(String(describing: youtubeTitle))")!
        
    }
    
    
    // 若有設定segue頁面，傳值過去 #目前此功能未用到#
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ReadYoutube" {
        
            print(self.tableView.indexPathForSelectedRow?.row)
        
            guard let youtubeViewController = segue.destination as? YoutubeViewController,
                
            let row = self.tableView.indexPathForSelectedRow?.row,
                
            let YoutubeTitle = self.youtubeItems[row].getID?.videoId
                
            else{ return }
            
            youtubeViewController.urlString = "https://www.youtube.com/watch?v=\(YoutubeTitle)"
            
        }
        
    }
    
    // 下一頁
    @IBAction func NextPage(_ sender: Any) {
        
        loadData()
  
    }
    
    // 上一頁
    @IBAction func PrevPage(_ sender: Any) {
        
        urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=\(SearchString)&type=video&key=AIzaSyDfgq-CbLXVX_ccXL8CfDh1LpaUk9ygcSU&pageToken=\(PrevPageToken)"
        
        print("Prev=\(PrevPageToken)")
        
        loadData()
        
    }
    
    // refresher時，就NextPage
    func refresherPage(){
     
        loadData()
        
        self.refresher?.endRefreshing()

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.mytableview.es_addInfiniteScrolling {
            
            [weak self] in
            self?.refresherPage()

            self?.mytableview.es_stopLoadingMore()

        }
  
        // inital RefreshControl
        refresher = UIRefreshControl()
       
        mytableview.addSubview(self.refresher!)
        
        // 下拉時顯示的內容
        self.refresher?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        // 下拉後要執行的func為何
        self.refresher?.addTarget(self, action: #selector(refresherPage), for: .valueChanged)
       
        //loadData()
        
        configureSearchController()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
