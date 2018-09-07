//
//  YotubeInfo.swift
//  youtubeTest
//
//  Created by Lai Evan on 9/26/17.
//  Copyright © 2017 Lai Evan. All rights reserved.
//

import ObjectMapper

class YotubeInfo: Mappable {
    
    var regionCode: String?
    
    var kind:String?
    
    var etag:String?
    
    var items:[YoutubeItem]?
    
    var nextPageToken:String?
    
    var prevPageToken:String?
    
    required init?(map: Map) {
        
        
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        regionCode  <- map["regionCode"]
        
        etag        <- map["etag"]
        
        items       <- map["items"]
        
        nextPageToken <- map["nextPageToken"]
        
        prevPageToken <- map["prevPageToken"]
        
    }
}


class YoutubeItem: Mappable {
    
    var snippet:YoutubeItemSnippet?
    
    var getID:YoutubeItemId?
    
    required init?(map: Map) {
        
        snippet     <- map["snippet"]
        
        getID       <- map["id"]

    }
    
    // Mappable
    func mapping(map: Map) {
        
     
    }
}


class YoutubeItemId: Mappable {
    
    var videoId:String?
    
    required init?(map: Map) {
        
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        videoId       <- map["videoId"]
        
    }
}

class YoutubeItemSnippet: Mappable {
    
    var title:String? // Channel title
    
    var publishedAt:String? // publist Date
    
    var description:String?
    
    var thumbnails:YoutubeThumbnails?
    
    required init?(map: Map) {
        
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        title           <- map["title"]
        
        publishedAt     <- map["publishedAt"]
        
        description     <- map["description"]
        
        thumbnails      <- map["thumbnails"]
        
    }
}

class YoutubeThumbnails: Mappable{
    
    var defaultImage:YoutubeDefault?
    
    required init?(map: Map) {
        
        defaultImage <- map["default"]
        
    }
    
    func mapping(map: Map) {
        
        
    }

}

class YoutubeDefault: Mappable{
    
    var url:String?
    
    var width:Int?
    
    var height:Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        url    <- map["url"]
        
        width  <- map["width"]
        
        height <- map["height"]
        
    }
}

