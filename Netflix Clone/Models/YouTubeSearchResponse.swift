//
//  YouTubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Aastha Aaryan on 15/11/24.
//

/*
 items =     (
             {
         etag = d9LYKwyMsaE0BEp1gkw7TCvPKf4;
         id =             {
             kind = "youtube#video";
             videoId = PJlNMcTvcsk;
         };
         kind = "youtube#searchResult";
     },
 */

import Foundation

struct YouTubeSearchResponse : Codable{
    
    let items : [VideoElement]
}

struct VideoElement : Codable {
    let id : IdVideoElement
}

struct IdVideoElement : Codable{
    let kind : String
    let videoId : String?
    let channelId : String?
    let playlistId : String?
}
