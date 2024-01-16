//
//  WaveLayer.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import UIKit

class WaveLayer: CALayer {
    
    @objc dynamic var U: CGFloat = 0
    @objc dynamic var C: CGFloat = 0
    
    var A: CGFloat = 1.0
    var W: CGFloat = 2 * .pi / 320 * 0.8
    var offsetU: CGFloat = 0
    var color: UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
    
    override init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
        self.A = 1.0
        self.W = 2 * .pi / 320 * 0.8
        self.C = 0
        self.U = 0
        self.offsetU = 0
        self.color = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let waveLayer = layer as? WaveLayer {
            self.A = waveLayer.A
            self.W = waveLayer.W
            self.C = waveLayer.C
            self.U = waveLayer.U
            self.offsetU = waveLayer.offsetU
            self.color = waveLayer.color
        }
    }
    
   
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "U" || key == "C" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    override func draw(in ctx: CGContext) {
        let clipPath = CGMutablePath()
        clipPath.addEllipse(in: bounds)
        ctx.addPath(clipPath)
        ctx.clip()
        
        ctx.setLineWidth(2.0)
        ctx.setFillColor(color.cgColor)
        
        let sinPath = CGMutablePath()
        let width = bounds.width
        let height = bounds.height
        
        let offsetY = (1 - C) * height
        sinPath.move(to: CGPoint(x: 0.0, y: height))
        sinPath.addLine(to: CGPoint(x: 0.0, y: offsetY))
        
        for x in stride(from: 0, through: width, by: 1) {
            let y = A * sin(W * x + U + offsetU) + offsetY
            sinPath.addLine(to: CGPoint(x: x, y: y))
        }
        
        sinPath.addLine(to: CGPoint(x: width, y: height))
        sinPath.closeSubpath()
        
        ctx.beginPath()
        ctx.addPath(sinPath)
        ctx.fillPath()
    }
}
