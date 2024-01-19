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

    @IBInspectable var fontSize: CGFloat = 12 {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
    }

    @IBInspectable var spacing: CGFloat = 7 {
        didSet {
            updateHeightConstraint()
        }
    }

    let titleLabel = UILabel()
    let percentageLabel = UILabel()

    @IBInspectable internal var percentage: Double = 0 {
        didSet {
            if percentage <= 100.0 {
                percentageLabel.text = "\(String(format: "%.2f", percentage)) %"
                waterWaveView.setProgress(percentage / 100, animated: true)
            } else {
                percentageLabel.text = "\(100) %"
                waterWaveView.setProgress(1, animated: true)
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
        backgroundColor = .clear

        titleLabel.text = subtitle
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        percentageLabel.backgroundColor = .clear
        percentageLabel.textColor = .white
        percentageLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        percentageLabel.textAlignment = .center

        addSubview(waterWaveView)
        addSubview(titleLabel)
        addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: waterWaveView.bottomAnchor, constant: spacing),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            waterWaveView.topAnchor.constraint(equalTo: self.topAnchor),
            waterWaveView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            waterWaveView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            waterWaveView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

        updateHeightConstraint()

        waterWaveView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
    }

    private func updateHeightConstraint() {
        let newHeight = frame.height + titleLabel.intrinsicContentSize.height + spacing
        self.updateHeightConstraint(to: newHeight)
    }
}
