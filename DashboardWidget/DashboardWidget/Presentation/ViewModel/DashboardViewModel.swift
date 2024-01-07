//
//  DashboardViewModel.swift
//  DashboardWidget
//
//  Created by Afzal Siddiqui on 05/01/2024.
//

import Combine
import UIKit

class DashboardViewModel {
    @Published private(set) var widgets: [Widget] = []

    private var cancellables: Set<AnyCancellable> = []
    
    func loadWidgets() {
        self.widgets = parseJSON(jsonName: "dashboard")
    }

    func rearrangeWidgets(with newOrder: [Int]) {
        widgets = widgets.sorted(by: { widget1, widget2 in
            guard let index1 = newOrder.firstIndex(of: widget1.id),
                  let index2 = newOrder.firstIndex(of: widget2.id) else {
                return false
            }
            return index1 < index2
        })
    }
}
