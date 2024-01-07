//
//  DataParser.swift
//  DashboardWidget
//
//  Created by Afzal Siddiqui on 06/01/2024.
//

import Foundation

func parseJSON(jsonName: String) -> [Widget] {
    if let path = Bundle.main.path(forResource: jsonName, ofType: "json"),
       let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)),
       let widgets = try? JSONDecoder().decode([Widget].self, from: jsonData) {
        return widgets
    }
    return []
}
