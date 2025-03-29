//
//  News.swift
//  ios101-project5-tumblr
//
//  Created by Richard M on 3/28/25.
//

import Foundation

// news article api
struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

// news article api
struct NewsArticle: Decodable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
}
