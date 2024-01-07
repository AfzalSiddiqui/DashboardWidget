//
//  WidgetCollectionViewCell.swift
//  DashboardWidget
//
//  Created by Afzal Siddiqui on 05/01/2024.
//

import UIKit
import Combine

class WidgetCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "WidgetCell"

    private var cancellables: Set<AnyCancellable> = []

    func configure(with widget: Widget) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        backgroundColor = UIColor(hex: widget.content.backgroundColor)
        addSubview(getHeaderLabel(widgetContent: widget))
        addSubview(getDetailsLabel(widgetContent: widget))
    }
    
    private func getHeaderLabel(widgetContent: Widget) -> UILabel {
        let label = UILabel()
        label.text = widgetContent.content.headerText
        label.textColor = UIColor(hex: widgetContent.content.headerTextColor)
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17.0)
        label.numberOfLines = 0
        label.frame = CGRect(x: self.bounds.origin.x,
                             y: self.bounds.origin.y,
                             width: self.bounds.width,
                             height: self.bounds.height/3)
        return label
    }
    
    private func getDetailsLabel(widgetContent: Widget) -> UILabel {
        let label = UILabel()
        label.text = widgetContent.content.detailText
        label.textColor = UIColor(hex: widgetContent.content.detailTextColor)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13.0)
        label.numberOfLines = 0
        label.frame = CGRect(x: self.bounds.origin.x,
                             y: self.bounds.origin.y + self.bounds.height/3,
                             width: self.bounds.width,
                             height: self.bounds.height - self.bounds.height/3)
        return label
    }
}
                                
