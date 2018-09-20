//
//  ProgressView.swift
//  ProgressView
//
//  Created by Grigory Avdyushin on 18/09/2018.
//  Copyright © 2018 Grigory Avdyushin. All rights reserved.
//

import UIKit

/// Base progress layer class
open class BaseProgressLayer: CALayer {

    /// Progress key path constant string
    enum Keys: String {
        case progress = "progress"
    }

    /// To work with CoreAnimation this property should be marked ass @NSManaged
    /// which generates getter and setter
    @NSManaged var progress: CGFloat

    /// Redraw during progress value animation
    override open class func needsDisplay(forKey key: String) -> Bool {
        if key == Keys.progress.rawValue {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
}

/// View with progress value and ability to update
public protocol ProgressableView {
    var progress: CGFloat { get }
    func update(_ progress: CGFloat, animated: Bool)
}

/// Progress view itself which supports animated progress value changes
public class ProgressView<Layer: BaseProgressLayer>: UIView, ProgressableView, CAAnimationDelegate {

    /// This view is backed by our Layer
    override class public var layerClass: AnyClass {
        return Layer.self
    }

    /// Update content scale to window's one
    override public func didMoveToWindow() {
        super.didMoveToWindow()

        if let window = window {
            progressLayer.contentsScale = window.screen.scale
            progressLayer.setNeedsDisplay()
        }
    }

    public var progress: CGFloat {
        return progressLayer.progress
    }

    public func update(_ progress: CGFloat, animated: Bool) {
        if animated {
            updateAnimated(progress)
        } else {
            updateInstantly(progress)
        }
    }

    var progressLayer: Layer {
        return self.layer as! Layer
    }

    private func updateInstantly(_ progress: CGFloat) {
        progressLayer.removeAnimation(forKey: BaseProgressLayer.Keys.progress.rawValue)
        progressLayer.progress = progress
        progressLayer.setNeedsDisplay()
    }

    private func updateAnimated(_ progress: CGFloat) {
        progressLayer.removeAnimation(forKey: BaseProgressLayer.Keys.progress.rawValue)
        let animation = CABasicAnimation(keyPath: BaseProgressLayer.Keys.progress.rawValue)
        let oldValue = progressLayer.presentation()?.progress ?? 0
        progressLayer.progress = oldValue
        animation.fromValue = oldValue
        animation.toValue = progress
        animation.duration = CFTimeInterval(fabsf(Float(oldValue - progress)))
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.delegate = self
        progressLayer.add(animation, forKey: BaseProgressLayer.Keys.progress.rawValue)
        debugPrint(oldValue, progress)
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let value = anim.value(forKey: "toValue") as? CGFloat {
            progressLayer.progress = value
        }
    }
}
