//
//  CircleProgressView.swift
//  ProgressView
//
//  Created by Grigory Avdyushin on 18/09/2018.
//  Copyright © 2018 Grigory Avdyushin. All rights reserved.
//

import UIKit

/// Layer to style circle view progress
public class CircleProgressLayer: BaseProgressLayer {

    @NSManaged var segmentsCount: Int
    @NSManaged var trackColor: UIColor
    @NSManaged var trackLineWidth: CGFloat
    @NSManaged var progressColor: UIColor
    @NSManaged var progressLineWidth: CGFloat

    override public func draw(in ctx: CGContext) {
        ctx.clear(self.bounds)
        drawTrack(in: ctx)
        drawProgress(in: ctx)
    }

    private var step: CGFloat {
        return CGFloat.pi * 2 / CGFloat(segmentsCount * 2)
    }

    private var radius: CGFloat {
        return min(self.bounds.width, self.bounds.height) / 2 - max(trackLineWidth, progressLineWidth) / 2
    }

    private var center: CGPoint {
        return CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    }

    private func drawTrack(in ctx: CGContext) {
        ctx.setLineWidth(trackLineWidth)
        ctx.setStrokeColor(trackColor.cgColor)
        drawSegmentes(in: ctx, progress: 1.0)
    }

    private func drawProgress(in ctx: CGContext) {
        ctx.setLineWidth(progressLineWidth)
        ctx.setStrokeColor(progressColor.cgColor)
        drawSegmentes(in: ctx, progress: progress)
    }

    private func drawSegmentes(in ctx: CGContext, progress: CGFloat) {
        if segmentsCount <= 1 {
            let circle = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: -CGFloat.pi / 2,
                endAngle: (progress * CGFloat.pi * 2) - CGFloat.pi / 2,
                clockwise: true
            )
            ctx.setLineCap(.round)
            ctx.addPath(circle.cgPath)
            ctx.strokePath()
        } else {
            let count = Int(CGFloat(segmentsCount) * progress)
            var current = -CGFloat.pi / 2
            for _ in 0..<count {
                let arc = UIBezierPath(
                    arcCenter: center,
                    radius: radius,
                    startAngle: current,
                    endAngle: current + step,
                    clockwise: true
                )
                ctx.setLineCap(.square)
                ctx.addPath(arc.cgPath)
                ctx.strokePath()
                current += step * 2
            }
        }
    }
}


/// Circle progress view width custom options
public class CircleProgressView: ProgressView<CircleProgressLayer> {

    public struct Options {
        let segmentsCount: Int
        let trackColor: UIColor
        let trackLineWidth: CGFloat
        let progressColor: UIColor
        let progressLineWidth: CGFloat

        public init(segmentsCount: Int = 1,
                    trackColor: UIColor = UIColor(red: 0, green: 148/255.0, blue: 50/255.0, alpha: 1.0),
                    trackLineWidth: CGFloat = 8,
                    progressColor: UIColor = UIColor(red: 196/255.0, green: 229/255.0, blue: 56/255.0, alpha: 1.0),
                    progressLineWidth: CGFloat = 6) {

            self.segmentsCount = segmentsCount
            self.trackColor = trackColor
            self.trackLineWidth = trackLineWidth
            self.progressColor = progressColor
            self.progressLineWidth = progressLineWidth
        }
    }

    var options: Options = Options() {
        didSet {
            applyOptions()
        }
    }

    convenience public init(options: Options) {
        self.init()

        self.options = options
        applyOptions()
    }

    private func applyOptions() {
        progressLayer.segmentsCount = options.segmentsCount
        progressLayer.trackColor = options.trackColor
        progressLayer.trackLineWidth = options.trackLineWidth
        progressLayer.progressColor = options.progressColor
        progressLayer.progressLineWidth = options.progressLineWidth
        progressLayer.setNeedsDisplay()
    }
}

/// Some extra sublcass with label
public class CircleWithLabelView: CircleProgressView {

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        return label
    }()

    override public func update(_ progress: CGFloat, animated: Bool) {
        super.update(progress, animated: animated)

        label.text = "\(Int(floor(progress * 100)))%"
    }
}
