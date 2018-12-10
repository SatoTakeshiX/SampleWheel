//
//  ViewController.swift
//  SampleWheel
//
//  Created by satoutakeshi on 2018/12/09.
//  Copyright © 2018年 Personal Factory. All rights reserved.
//

import UIKit
import WheelView

class ViewController: UIViewController {

    @IBOutlet weak var wheelView: WheelView!
    @IBOutlet weak var digreeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        wheelView.delegate = self
    }
}

extension ViewController: RotaryProtocol {
    func updatedRagianAngle(wheelView: WheelView, angle: CGFloat) {
        print("radian: \(angle)")
        let digree = angle * 180 / .pi
        print("digree: \(digree)")

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.positiveFormat = "0.0" // "0.#" -> 0パディングしない
        formatter.roundingMode = .halfUp // 四捨五入 // .floor -> 切り捨て
        let digreeString = formatter.string(for: digree) ?? ""

        digreeLabel.text = "角度: \(digreeString)°"
    }


}

