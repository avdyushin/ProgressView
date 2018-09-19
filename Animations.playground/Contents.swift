//
//  Animations.playground
//  ProgressView
//
//  Created by Grigory Avdyushin on 18/09/2018.
//  Copyright © 2018 Grigory Avdyushin. All rights reserved.
//

import UIKit
import PlaygroundSupport

/// Helper class to update banch of progresses
class ProgressController {
    let views: [ProgressableView]

    init(_ views: ProgressableView...) {
        self.views = views
    }

    @objc
    func onSlider(_ sender: UISlider) {
        update(CGFloat(sender.value))
    }

    func update(_ progress: CGFloat) {
        views.forEach {
            $0.update(progress, animated: true)
        }
    }
}

let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 580))
containerView.backgroundColor = .white

let circleOptions = CircleProgressView.Options()
let circleProgressView = CircleProgressView(options: circleOptions)
circleProgressView.backgroundColor = .white

let lineOptions = LineProgressView.Options(segmentsCount: 0, lineWidth: 8)
let lineProgressView = LineProgressView(options: lineOptions)
lineProgressView.backgroundColor = .white

let labelOptions = CircleWithLabelView.Options(
    segmentsCount: 12,
    trackColor: UIColor(red: 238.0/255.0, green: 90.0/255.0, blue: 36.0/255.0, alpha: 1.0),
    progressColor: UIColor(red: 255.0/255.0, green: 195.0/255.0, blue: 18.0/255.0, alpha: 1.0)
)

let labelProgressView = CircleWithLabelView(options: labelOptions)
labelProgressView.backgroundColor = .white

let progressController = ProgressController(circleProgressView, lineProgressView, labelProgressView)

let sliderView = UISlider(frame: CGRect(x: 0, y: 0, width: 256, height: 40))
sliderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
sliderView.isContinuous = false
sliderView.addTarget(progressController, action: #selector(progressController.onSlider(_:)), for: .valueChanged)

let dummyView = UIView()
dummyView.backgroundColor = .white
dummyView.addSubview(sliderView)

let stackView = UIStackView(arrangedSubviews: [
    circleProgressView,
    lineProgressView,
    labelProgressView,
    dummyView
])

stackView.axis = .vertical
stackView.alignment = .fill
stackView.distribution = .fillEqually
stackView.spacing = 16

stackView.translatesAutoresizingMaskIntoConstraints = false
containerView.addSubview(stackView)

NSLayoutConstraint.activate([
    stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 32),
    stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -32),
    stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
    stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
])

sliderView.frame = dummyView.bounds

sliderView.setValue(0.33, animated: true)
progressController.update(0.33)

PlaygroundPage.current.liveView = containerView
