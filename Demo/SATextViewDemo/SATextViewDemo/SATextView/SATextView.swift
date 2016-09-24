//
//  SATextView.swift
//  SATextView
//
//  Created by Michael Schmidt on 9/24/16.
//  Copyright © 2016 SchmidtyApps. All rights reserved.
//

import UIKit

class SATextView: UITextView {

    /** Adds placeholder text to simulate the behavior of a UITextField**/
    var placeholderText : String = ""
    
    private var isPlaceholderShowing : Bool = false
    
    private var fauxDelegate : UITextViewDelegate?
    private var realDelegate : UITextViewDelegate?
    
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
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        fauxDelegate = self
        setTextViewPlaceholderIfNeeded()
    }
    
    required override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer : textContainer)
        fauxDelegate = self
        setTextViewPlaceholderIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fauxDelegate = self
        setTextViewPlaceholderIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setTextViewPlaceholderIfNeeded()
    }
    
}

extension SATextView : UITextViewDelegate {
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        guard let shouldBegin = realDelegate?.textViewShouldBeginEditing?(textView) else {return true}
        
        return shouldBegin
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        guard let shouldEnd = realDelegate?.textViewShouldEndEditing?(textView) else {return true}
        
        return shouldEnd
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        setTextViewPlaceholderIfNeeded()
        realDelegate?.textViewDidBeginEditing?(textView)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        realDelegate?.textViewDidEndEditing?(textView)
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newFullString = (textView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
        
        
        
        if let shouldChange = realDelegate?.textView?(textView, shouldChangeTextInRange: range, replacementText: text) where shouldChange == false {
            return false
        }
        
        if(newFullString == "") {
            setTextViewPlaceholder()
            return false
        }
        else if(isPlaceholderShowing) {
            if(text != "") {
                textView.text = ""
                isPlaceholderShowing = false
                self.textColor = UIColor.blackColor()
            }
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        realDelegate?.textViewDidChange?(textView)
    }
    
    private func setTextViewPlaceholderIfNeeded() {
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let selfy = self else {return}
            
            if (selfy.text == "" || selfy.text == selfy.placeholderText) {
                selfy.setTextViewPlaceholder()
            }
            })
    }
    
    private func setTextViewPlaceholder() {
        dispatch_async(dispatch_get_main_queue(), {[weak self] in
            guard let selfy = self else {return}
            
            selfy.textColor = UIColor.grayColor()
            selfy.text = selfy.placeholderText
            
            selfy.selectedRange = NSMakeRange(0, 0);
            
            selfy.isPlaceholderShowing = true
            })
    }
    
    
    
    func textViewDidChangeSelection(textView: UITextView) {
        if(isPlaceholderShowing) {
            setTextViewPlaceholder()
        }
        
        realDelegate?.textViewDidChangeSelection?(textView)
    }
    
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        guard let shouldInteract = realDelegate?.textView?(textView, shouldInteractWithURL: URL, inRange: characterRange) else {return true}
        
        return shouldInteract
    }
    
    func textView(textView: UITextView, shouldInteractWithTextAttachment textAttachment: NSTextAttachment, inRange characterRange: NSRange) -> Bool {
        guard let shouldInteract = realDelegate?.textView?(textView, shouldInteractWithTextAttachment: textAttachment, inRange: characterRange) else {return true}
        
        return shouldInteract
    }
}
