//
//  LineProgressView.swift
//  ProgressView
//
//  Created by Grigory Avdyushin on 18/09/2018.
//  Copyright © 2018 Grigory Avdyushin. All rights reserved.
//

import UIKit

/// Layer to style a line view progress
public class LineProgressLayer: BaseProgressLayer {

    @NSManaged var segmentsCount: Int
    @NSManaged var lineWidth: CGFloat
    @NSManaged var spacing: CGFloat
    @NSManaged var trackColor: UIColor
    @NSManaged var progressColor: UIColor

    override public func draw(in ctx: CGContext) {
        ctx.clear(self.bounds)
        drawTrack(in: ctx)
        drawProgress(in: ctx)
    }

    private var segmentWidth: CGFloat {
        return (self.bounds.width - CGFloat(segmentsCount - 1) * spacing) / CGFloat(segmentsCount)
    }

    private var centerY: CGFloat {
        return self.bounds.midY - lineWidth / 2
    }

    private func drawTrack(in ctx: CGContext) {
        ctx.setFillColor(trackColor.cgColor)
        drawSegments(in: ctx, progress: 1.0)
    }

    private func drawProgress(in ctx: CGContext) {
        ctx.setFillColor(progressColor.cgColor)
        drawSegments(in: ctx, progress: progress)
    }

    private func drawSegments(in ctx: CGContext, progress: CGFloat) {
        if segmentsCount <= 1 {
            let rect = UIBezierPath(roundedRect: CGRect(
                x: -lineWidth / 2,
                y: centerY,
                width: (bounds.width + lineWidth) * progress,
                height: lineWidth
            ), cornerRadius: lineWidth / 2)
            ctx.addPath(rect.cgPath)
            ctx.fillPath()
        } else {
            let count = Int(CGFloat(segmentsCount) * progress)
            for i in 0..<count {
                ctx.fill(CGRect(
                    x: CGFloat(i) * (segmentWidth + spacing),
                    y: centerY,
                    width: segmentWidth,
                    height: lineWidth
                ))
            }
        }
    }
}

/// Line progress view with custom options
public class LineProgressView: ProgressView<LineProgressLayer> {

    public struct Options {
        let segmentsCount: Int
        let spacing: CGFloat
        let lineWidth: CGFloat
        let trackColor: UIColor
        let progressColor: UIColor

        public init(segmentsCount: Int = 1,
                    spacing: CGFloat = 4,
                    lineWidth: CGFloat = 8,
                    trackColor: UIColor = UIColor(red: 0, green: 98/255.0, blue: 102/255.0, alpha: 1.0),
                    progressColor: UIColor = UIColor(red: 18/255.0, green: 203/255.0, blue: 196/255.0, alpha: 1.0)) {

            self.segmentsCount = segmentsCount
            self.spacing = spacing
            self.lineWidth = lineWidth
            self.trackColor = trackColor
            self.progressColor = progressColor
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
        progressLayer.spacing = options.spacing
        progressLayer.lineWidth = options.lineWidth
        progressLayer.trackColor = options.trackColor
        progressLayer.progressColor = options.progressColor
        progressLayer.setNeedsDisplay()
    }
}
