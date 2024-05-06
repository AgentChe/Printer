//
//  CenteredFlowLayout.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/6/24.
//

import UIKit

class CenteredFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = self.collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }

        let collectionViewBounds = collectionView.bounds
        let halfWidth = collectionViewBounds.size.width * 0.5
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        let layoutAttributesArray = self.layoutAttributesForElements(in: collectionViewBounds)

        var candidateAttributes: UICollectionViewLayoutAttributes?
        for attributes in layoutAttributesArray ?? [] {
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        //because blinking buggy efffect occurs
        if let candidateAttributes = candidateAttributes {
            var newOffset = CGPoint(x: candidateAttributes.center.x - halfWidth, y: proposedContentOffset.y)
            if newOffset.x <= 0 {
                newOffset.x = 0
            }
            if newOffset.x + ScreenSize.width >= collectionView.contentSize.width {
                newOffset.x = collectionView.contentSize.width - ScreenSize.width
            }
            
            scrollToContentOffset(collectionView: collectionView, mass: 1.0, stiffness: 400.0, damping: 3000.0, initialVelocity: CGVector(dx: velocity.x, dy: 0), targetOffset: newOffset)
            return newOffset
        } else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
    }

    private func scrollToContentOffset(collectionView: UICollectionView, mass: CGFloat, stiffness: CGFloat, damping: CGFloat, initialVelocity: CGVector, targetOffset: CGPoint) {
        let timingParameters = UISpringTimingParameters(mass: mass, stiffness: stiffness, damping: damping, initialVelocity: initialVelocity)
        let propertyAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: timingParameters)

        propertyAnimator.addAnimations {
            collectionView.setContentOffset(targetOffset, animated: false)
        }

        propertyAnimator.startAnimation()
    }
}
