//
//  WheelView.swift
//  SampleWheel
//
//  Created by satoutakeshi on 2018/12/09.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit

@IBDesignable
class WheelView: UIView {

    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    @IBInspectable var contentModeNumber: Int = 0 {
        didSet {
            guard let mode = UIView.ContentMode.init(rawValue: contentModeNumber) else { return }
            imageView.contentMode = mode
        }
    }

    //
    private let imageView = UIImageView(frame: CGRect())

    // これはViewがもっているべきか、マネージャーか。
    var startTransform: CGAffineTransform?
    var deltaAngle: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        // imageViewを上下左右いっぱいに制約をつける
        imageView.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0).isActive = true
        imageView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0).isActive = true
        imageView.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0).isActive = true
        imageView.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // タッチ開始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let manager = CoordinateManager()
        let touchPoint = touch.location(in: self)
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let dist = manager.calculateDistance(center: center, point: touchPoint)

        // タッチ範囲外
        if manager.isIgnoreRange(distance: dist, size: self.bounds.size) {
            print("ignoring tap \(touchPoint.x), \(touchPoint.y)")
            return
        }

        deltaAngle = manager.makeDeltaAngle(targetPoint: touchPoint, center: self.center)
        startTransform = self.transform
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let manager = CoordinateManager()
        let touchPoint = touch.location(in: self)
        let center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        let dist = manager.calculateDistance(center: center, point: touchPoint)
        // タッチ範囲外
        if manager.isIgnoreRange(distance: dist, size: self.bounds.size) {
            print("ignoring tap \(touchPoint.x), \(touchPoint.y)")
            return
        }

        let targetAngle = manager.makeDeltaAngle(targetPoint: touchPoint, center: self.center)
        let angleDifference = deltaAngle - targetAngle
        transform = startTransform?.rotated(by: -angleDifference) ?? CGAffineTransform.identity
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

}
