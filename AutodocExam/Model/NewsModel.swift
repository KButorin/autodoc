//
//  NewsModel.swift
//  AutodocExam
//
//  Created by ESSIP on 24.03.2025.
//

import Foundation

// MARK: - News
struct News: Codable, Hashable {
    let news: [NewsElement]
    let totalCount: Int
}

// MARK: - NewsElement
struct NewsElement: Codable, Hashable {
    let id: Int
    let title, description, publishedDate, url: String
    let fullURL: String
    let titleImageURL: String
    let categoryType: CategoryType

    enum CodingKeys: String, CodingKey {
        case id, title, description, publishedDate, url
        case fullURL = "fullUrl"
        case titleImageURL = "titleImageUrl"
        case categoryType
    }
}

enum CategoryType: String, Codable {
    case автомобильныеНовости = "Автомобильные новости"
    case новостиКомпании = "Новости компании"
}
