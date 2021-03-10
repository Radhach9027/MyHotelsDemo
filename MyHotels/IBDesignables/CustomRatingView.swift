//  CustomRatingView.swift
//  MyHotels
//  Created by radha chilamkurthy on 08/03/21.

import UIKit

@objc public protocol RatingViewDelegate {
    func ratingView(_ ratingView: CustomRatingView, didChangeRating newRating: Float)
}


@IBDesignable
open class CustomRatingView: UIView {
    
    @IBInspectable open var starCount: Int = 5
    
    @IBInspectable open var offImage: UIImage?
    
    @IBInspectable open var onImage: UIImage?
    
    @IBInspectable open var halfImage: UIImage?
    
    @IBInspectable open var rating: Float = 0 {
        didSet {
            rating = min(Float(starCount), rating)
            updateRating()
        }
    }
    
    @IBInspectable open var halfStarsAllowed: Bool = true
    
    @IBInspectable open var editable: Bool = true
    
    @objc open weak var delegate: RatingViewDelegate?
    
    var stars: [UIImageView] = []
    
    override open var semanticContentAttribute: UISemanticContentAttribute {
        didSet {
            updateTransform()
        }
    }
    
    private var shouldUseRightToLeft: Bool {
        return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
            == .rightToLeft
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        customInit()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        customInit()
    }
    
    func customInit() {
        
        if offImage == nil {
            offImage = UIImage(systemName: "star", compatibleWith: self.traitCollection)
        }
        if onImage == nil {
            onImage = UIImage(systemName: "star.fill", compatibleWith: self.traitCollection)
        }
        
        if halfImage == nil {
            halfImage = UIImage(systemName: "star.leadinghalf.fill", compatibleWith: self.traitCollection)
        }
        
        guard let offImage = offImage else {
            assert(false, "offImage is not set")
            return
        }
        
        var i = 1
        while i <= starCount {
            let iv = UIImageView(image: offImage)
            addSubview(iv)
            stars.append(iv)
            i += 1
        }
        
        layoutStars()
        updateRating()
        
        updateTransform()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        layoutStars()
    }
    
    private func updateTransform() {
        transform = shouldUseRightToLeft
            ? CGAffineTransform.init(scaleX: -1, y: 1)
            : .identity
    }
    
    private func layoutStars() {
        guard !stars.isEmpty, let offImage = stars.first?.image else {
            return
        }
        
        let halfWidth = offImage.size.width/2
        let distance = (bounds.size.width - (offImage.size.width * CGFloat(starCount))) / CGFloat(starCount + 1) + halfWidth
        
        for (index, iv) in stars.enumerated() {
            iv.frame = CGRect(x: 0, y: 0, width: offImage.size.width, height: offImage.size.height)
            
            iv.center = CGPoint(
                x: CGFloat(index + 1) * distance + halfWidth * CGFloat(index),
                y: self.frame.size.height/2
            )
        }
    }
    

    func handleTouches(_ touches: Set<UITouch>) {
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        var i = starCount - 1
        while i >= 0 {
            let imageView = stars[i]
            
            let x = touchLocation.x;
            
            if x >= imageView.center.x {
                rating = Float(i) + 1
                return
            } else if x >= imageView.frame.minX && halfStarsAllowed {
                rating = Float(i) + 0.5
                return
            }
            i -= 1
        }
        
        
        rating = 0
    }

    func updateRating() {
        guard !stars.isEmpty else {
            return
        }
        
        var i = 1
        while i <= Int(rating) {
            let star = stars[i-1]
            star.image = onImage
            i += 1
        }
        
        if i > starCount {
            return
        }
        
        if rating - Float(i) + 1 >= 0.5 {
            let star = stars[i-1]
            star.image = halfImage
            i += 1
        }
        
        while i <= starCount {
            let star = stars[i-1]
            star.image = offImage
            i += 1
        }
    }
}

extension CustomRatingView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard editable else { return }
        handleTouches(touches)
        guard let delegate = delegate else { return }
        delegate.ratingView(self, didChangeRating: rating)
    }
}

@objc extension CustomRatingView {
    @objc public enum FillDirection: Int {
        case automatic
        case leftToRight
        case rightToLeft
    }
}
