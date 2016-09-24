# SATextView
A UITextView replacement that allows placeholder text and adding a border that simulates the look of UITextField but allows multi line input

## Usage

`placeholderText` property is set similar to UITextField.
`addBorder()` can be called to simulate the look of a UITextField.

### Code

```swift
let textView = SATextView()//Initialize or just get reference from .Xib
textView.placeholder = "Optional"
textView.addBorder()//Simulates the look of UITextField border
```

