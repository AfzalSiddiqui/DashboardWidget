//
//  DashboardViewController.swift
//  DashboardWidget
//
//  Created by Afzal Siddiqui on 05/01/2024.
//

import UIKit
import Combine

class DashboardViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!

    private var viewModel = DashboardViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
        viewModel.loadWidgets()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
            collectionView.addGestureRecognizer(longPressGesture)
        
        self.view.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        self.collectionView.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
    }
    
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let previewParameters = UIDragPreviewParameters()
        previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 80)) // Customize the visible path
        return previewParameters
    }

    private func configureCollectionView() {
        let layout = CenteredLeftAlignedFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.reorderingCadence = .fast // Optional: Set the reordering cadence
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(WidgetCollectionViewCell.self, forCellWithReuseIdentifier: WidgetCollectionViewCell.reuseIdentifier)
    }

    private func bindViewModel() {
        viewModel.$widgets
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.widgets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WidgetCollectionViewCell.reuseIdentifier, for: indexPath) as? WidgetCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 6
        cell.layer.masksToBounds = true
        let widget = viewModel.widgets[indexPath.item]
        cell.configure(with: widget)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widget = viewModel.widgets[indexPath.item]
        switch widget.size {
        case .square:
            return CGSize(width: collectionView.frame.width/3 - 8, height: collectionView.frame.width/3 - 8)
        case .mini:
            return CGSize(width: collectionView.frame.width, height: 115)
        case .large:
            return CGSize(width: collectionView.frame.width, height: 191)
        case .large_square:
            return CGSize(width: collectionView.frame.width/2 - 8, height: collectionView.frame.width/2 - 8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var newOrder = viewModel.widgets.map { $0.id }
        newOrder.swapAt(sourceIndexPath.item, destinationIndexPath.item)
        viewModel.rearrangeWidgets(with: newOrder)
    }
}
