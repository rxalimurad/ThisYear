//
//  ProgressWidget.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import UIKit

class ProgressWidget: UIView {
    let waterWaveView = LKAWaveCircleProgressBar()
    @IBInspectable var subtitle: String = "Year" {
        didSet {
            titleLabel.text = subtitle
        }
    }
    @IBInspectable var fontSize: CGFloat = 12
    @IBInspectable var spacing: CGFloat = -7
    let titleLabel = UILabel()
    let percentageLabel = UILabel()

    
    @IBInspectable internal var percentage: Double = 0 {
        didSet {
            if percentage <= 100.0 {
                percentageLabel.text = "\(percentage) %"
                self.waterWaveView.setProgress(percentage / 100, animated: true)
            } else {
                percentageLabel.text = "\(100) %"
                self.waterWaveView.setProgress(1, animated: true)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        self.backgroundColor = .clear
        titleLabel.text = subtitle
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        titleLabel.textAlignment = .center
        
        percentageLabel.backgroundColor = .clear
        percentageLabel.textColor = .white
        percentageLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        percentageLabel.textAlignment = .center
        
        
        
        addSubview(waterWaveView)
        addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            waterWaveView.topAnchor.constraint(equalTo: self.topAnchor),
            waterWaveView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            waterWaveView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            waterWaveView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            waterWaveView.heightAnchor.r
//            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        self.updateHeightConstraint(to: self.frame.height + titleLabel.intrinsicContentSize.height - spacing)
        waterWaveView.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
//            self.waterWaveView.percentAnim()
        }
    }
    
}
