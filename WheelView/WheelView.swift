//
//  WheelView.swift
//  SampleWheel
//
//  Created by satoutakeshi on 2018/12/09.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit

public protocol RotaryProtocol: class {
    func updatedRagianAngle(wheelView: WheelView, angle: CGFloat)
}

@IBDesignable
 public class WheelView: UIView {

    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    @IBInspectable var contentModeNumber: Int = 0 {
        didSet {
            guard let mode = UIView.ContentMode(rawValue: contentModeNumber) else { return }
            imageView.contentMode = mode
        }
    }

    //
    private let imageView = UIImageView(frame: CGRect())

    // タップ開始時のTransform
    var startTransform: CGAffineTransform?
    // タップ座標と中心点の角度
    var deltaAngle: CGFloat = 0.0

    weak public var delegate: RotaryProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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


    // タッチ開始
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let targetAngle = makeDeltaAngle(touches: touches) else { return }
        deltaAngle = targetAngle
        startTransform = imageView.transform
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let targetAngle = makeDeltaAngle(touches: touches) else { return }
        let angleDifference = deltaAngle - targetAngle
        imageView.transform = startTransform?.rotated(by: -angleDifference) ?? CGAffineTransform.identity
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 回転をtransformから算出
        var angle = atan2(imageView.transform.b, imageView.transform.a)
        // ラジアン範囲を -.pi < Θ < pi から 0 < Θ < 2 piに変更
        if angle < 0 {
            angle += 2 * .pi
        }
        delegate?.updatedRagianAngle(wheelView: self, angle: angle)
    }

    private func makeDeltaAngle(touches: Set<UITouch>) -> CGFloat? {
        guard let touch = touches.first else { return nil }
        let manager = CoordinateManager()
        let touchPoint = touch.location(in: self)
        let center = CGPoint(x: imageView.bounds.width/2, y: imageView.bounds.height/2)
        let dist = manager.calculateDistance(center: center, point: touchPoint)

        // タッチ範囲外
        if manager.isIgnoreRange(distance: dist, size: imageView.bounds.size) {
            print("ignoring tap \(touchPoint.x), \(touchPoint.y)")
            return nil
        }

        return manager.makeDeltaAngle(targetPoint: touchPoint, center: imageView.center)
    }
}
