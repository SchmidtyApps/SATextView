//
//  SATextView.swift
//  SATextView
//
//  Created by Michael Schmidt on 9/24/16.
//  Copyright © 2016 SchmidtyApps. All rights reserved.
//

import UIKit

/**
 This is a custom UITextView that mimics UITextField but allows for multiline inputs and can grow as the user types
 **/
class SATextView: UITextView {
    
    /** Adds placeholder text to simulate the behavior of a UITextField**/
    var placeholder : String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    fileprivate var placeholderLabel : UILabel = UILabel()
    
    fileprivate var isPlaceholderShowing : Bool {
        get{
            return !placeholderLabel.isHidden
        }
    }
    
    override var text: String! {
        didSet{
            placeholderLabel.isHidden = text == "" ? false : true
        }
    }
    
    fileprivate weak var fauxDelegate : UITextViewDelegate?
    fileprivate weak var realDelegate : UITextViewDelegate?
    
    //Intercept the delegate so we can do what we need to before passing along to whoever the delegate is for this text view
    override var delegate: UITextViewDelegate? {
        set {
            super.delegate = fauxDelegate
            realDelegate = newValue
        }
        get{
            return fauxDelegate
        }
    }
    
    /** Adds a border to simulate the look of a UITextField**/
    func addBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    /** Removes the border that simulates the look of a UITextField**/
    func removeBorder() {
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    //If we are in interface builder for the IBDesignable we need to handle styling the button slightly differently otherwise IB gets messed up and shows blank VCs
    #if TARGET_INTERFACE_BUILDER
    override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
        addBorder()
    }
    
    #else
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        setupPlaceholderLabel()
        fauxDelegate = self
        showHideTextViewPlaceholder()
        addBorder()
    }
    
    required override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer : textContainer)
        setupPlaceholderLabel()
        
        fauxDelegate = self
        showHideTextViewPlaceholder()
        addBorder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //addDoneToolbar()
        setupPlaceholderLabel()
        fauxDelegate = self
        showHideTextViewPlaceholder()
        addBorder()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        showHideTextViewPlaceholder()
    }
    
    fileprivate func setupPlaceholderLabel() {
        guard !self.subviews.contains(placeholderLabel) else {return}
        
        self.addSubview(placeholderLabel)
        placeholderLabel.pinLeftToLeftOf(self, padding: 5)
        placeholderLabel.pinCenterXToCenterXOf(self)
        placeholderLabel.pinCenterYToCenterYOf(self)
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = .gray
    }
    
    #endif
    
}

//MARK: - UITextViewDelegate where we handle most of the logic for adding placeholder text etc
extension SATextView : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let shouldBegin = realDelegate?.textViewShouldBeginEditing?(textView) else {return true}
        return shouldBegin
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let shouldEnd = realDelegate?.textViewShouldEndEditing?(textView) else {return true}
        
        return shouldEnd
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        showHideTextViewPlaceholder()
        realDelegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        realDelegate?.textViewDidEndEditing?(textView)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let shouldChange = realDelegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) else {
            return true
        }
        
        return shouldChange
    }
    
    func textViewDidChange(_ textView: UITextView) {
        showHideTextViewPlaceholder()
        realDelegate?.textViewDidChange?(textView)
    }
    
    fileprivate func showHideTextViewPlaceholder() {
        placeholderLabel.isHidden = self.text != ""
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        showHideTextViewPlaceholder()
        realDelegate?.textViewDidChangeSelection?(textView)
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let shouldInteract = realDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) else {return true}
        
        return shouldInteract
    }
    
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        guard let shouldInteract = realDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) else {return true}
        
        return shouldInteract
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        guard let shouldInteract = realDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange) else {return true}
        
        return shouldInteract
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        guard let shouldInteract = realDelegate?.textView?(textView, shouldInteractWith: textAttachment, in: characterRange) else {return true}
        
        return shouldInteract
    }

}

extension UIView {
    fileprivate func pinLeftToLeftOf(_ view : UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.left,
            multiplier: 1,
            constant: padding)
        
        constraint.isActive = true
    }
    
    fileprivate func pinCenterXToCenterXOf(_ view : UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.centerX,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.centerX,
            multiplier: 1,
            constant: padding)
        
        constraint.isActive = true
    }
    
    fileprivate func pinCenterYToCenterYOf(_ view : UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutAttribute.centerY,
            relatedBy: NSLayoutRelation.equal,
            toItem: view,
            attribute: NSLayoutAttribute.centerY,
            multiplier: 1,
            constant: padding)
        
        constraint.isActive = true
    }
}
