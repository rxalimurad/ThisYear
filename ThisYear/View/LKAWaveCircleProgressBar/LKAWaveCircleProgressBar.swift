//
//  LKAWaveCircleProgressBar.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import UIKit

typealias Completion = () -> Void

class LKAWaveCircleProgressBar: UIView {
    
    var waveRollingDuration: TimeInterval = 1.0
    var progressAnimationDuration: TimeInterval = 1.0
    var progress: CGFloat = 0.1
    var borderColor: UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.9)
    var borderWidth: CGFloat = 2.0
    var completion: Completion?
    
    private var waves: [WaveLayer] = []
    private var containerLayer: CALayer!
    private var isStop: Bool = true
    private var isAnimating: Bool = false
    private var colors = [UIColor.systemOrange, .systemPink]
    // MARK: - Custom view initialization
    
    private func initialization() {
        waveRollingDuration = 1.0
        progressAnimationDuration = 1.0
        progress = 0.1
        borderColor = colors[0]
        borderWidth = 2.0
        isStop = true
        isAnimating = false
        
        for index in 0..<2 {
            let waveLayer = WaveLayer()
            waveLayer.color = colors[index]
            waveLayer.C = progress
            waveLayer.offsetU = CGFloat(waves.count) * .pi * 0.8
            lazyContainerLayer.addSublayer(waveLayer)
            waves.append(waveLayer)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(startWaveRollingAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopWaveRollingAnimation), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    // MARK: - Lazy loading property
    
    private var lazyContainerLayer: CALayer {
        if containerLayer == nil {
            containerLayer = CALayer()
            containerLayer.contentsScale = UIScreen.main.scale
            containerLayer.masksToBounds = true
            containerLayer.borderColor = borderColor.cgColor
            containerLayer.borderWidth = borderWidth
            layer.addSublayer(containerLayer)
        }
        return containerLayer
    }
    
    private lazy var lazyWaves: [WaveLayer] = []
    
    // MARK: - API property
    func addProgressAnimation(from: TimeInterval, to: TimeInterval) {
        let progressAnimation = CABasicAnimation(keyPath: "C")
        progressAnimation.fromValue = from
        progressAnimation.toValue = to
        progressAnimation.duration = self.progressAnimationDuration
        progressAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressAnimation.setValue("ProgressAnimation", forKey: "Name")
        
        for i in 0..<self.waves.count {
            if i == 0 {
                progressAnimation.delegate = self
            } else {
                progressAnimation.delegate = nil
            }
            let layer = self.waves[i]
            layer.add(progressAnimation, forKey: "ProgressAnimation")
        }
    }
    func setProgress(_ progress: CGFloat, animated: Bool) {
        let lastProgress = self.progress
        self.progress = min(1.0, max(0.0, progress))
        for i in 0..<self.waves.count {
            let waveLayer = self.waves[i]
            waveLayer.C = self.progress
        }
        if animated {
            addProgressAnimation(from: TimeInterval(lastProgress), to: TimeInterval(self.progress))

        }
    }

    
    @objc func stopWaveRollingAnimation() {
        isStop = true
        if isAnimating {
            isAnimating = false
            removeWaveRollingAnimation()
        }
    }
    
    @objc func startWaveRollingAnimation() {
        isStop = false
        if !isAnimating {
            isAnimating = true
            addWaveRollingAnimation()
        }
    }
    
    // MARK: - Prepare to layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
       // assert(width == bounds.height, "LKAWaveCircleProgressBar MUST BE SQUARE!")
        lazyContainerLayer.frame = bounds
        lazyContainerLayer.cornerRadius = width / 2.0 + 0.5
        
        let waveFrame = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        
        for (i, waveLayer) in waves.enumerated() {
            waveLayer.frame = waveFrame
            waveLayer.A = waveFrame.size.width * (-0.05 - 0.03 * CGFloat(i))
            waveLayer.W = 2 * .pi / waveFrame.size.width * 0.8
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if !isStop {
            startWaveRollingAnimation()
        }
    }
    
    private func addWaveRollingAnimation() {
        let waveRollingAnim = CABasicAnimation(keyPath: "U")
        waveRollingAnim.fromValue = 0
        waveRollingAnim.toValue = 2 * CGFloat.pi
        waveRollingAnim.repeatCount = .greatestFiniteMagnitude
        waveRollingAnim.isRemovedOnCompletion = false
        waveRollingAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        
        for (i, waveLayer) in waves.enumerated() {
            waveRollingAnim.duration = waveRollingDuration + (TimeInterval(i) * 0.3)
            waveLayer.add(waveRollingAnim, forKey: "WaveRollingAnimation")
        }
    }
    
    private func removeWaveRollingAnimation() {
        for layer in waves {
            layer.removeAnimation(forKey: "WaveRollingAnimation")
        }
    }
}

extension LKAWaveCircleProgressBar: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let name = anim.value(forKey: "Name") as? String, name == "ProgressAnimation" {
            completion?()
        }
    }
}
