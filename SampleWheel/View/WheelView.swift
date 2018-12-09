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

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    // フレームの更新
    // すべての制約がframe値への置き換え計算が終わっている
    override func layoutSubviews() {
        super.layoutSubviews() //最初に呼ぶ
    }

    // 制約が更新されたら呼ばれる
    override func updateConstraints() {

        // 処理

        super.updateConstraints() //最後にsuperを呼ぶ
    }

}
