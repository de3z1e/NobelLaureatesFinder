//
//  BorderedButton.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/28/21.
//

import UIKit

class BorderedButton: UIButton {
    var cornerRadius: CGFloat = 10
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setAttributes()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(isHighlighted))
        removeObserver(self, forKeyPath: #keyPath(isEnabled))
    }
    
    private func setAttributes() {
        addObserver(self, forKeyPath: #keyPath(isHighlighted), options: [.new], context: nil)
        addObserver(self, forKeyPath: #keyPath(isEnabled), options: [.new], context: nil)
        layer.cornerRadius = cornerRadius
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(isHighlighted) {
            configureUIState(isHighlighted: isHighlighted)
        } else if keyPath == #keyPath(isEnabled) {
            alpha = isEnabled ? 1.0 : 0.3
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func configureUIState(isHighlighted: Bool) {
        if isHighlighted {
            layer.removeAllAnimations()
            backgroundColor = backgroundColor?.withAlphaComponent(0.5)
        } else {
            UIViewPropertyAnimator(duration: 0.3, curve: .linear) { [weak self] in
                self?.backgroundColor = self?.backgroundColor?.withAlphaComponent(1.0)
            }.startAnimation()
        }
    }
}
