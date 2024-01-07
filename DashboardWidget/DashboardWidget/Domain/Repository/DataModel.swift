//
//  DataModel.swift
//  DashboardWidget
//
//  Created by Afzal Siddiqui on 06/01/2024.
//

import CoreGraphics

enum WidgetSize: String, Decodable {
    case mini, square, large, large_square
}

struct Widget: Decodable {
    let id: Int
    let size: WidgetSize
    let content: ContentModel
}

struct ContentModel: Decodable {
    let headerText: String
    let detailText: String
    let headerTextColor: String
    let detailTextColor: String
    let backgroundColor: String
}
