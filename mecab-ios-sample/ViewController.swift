//
//  ViewController.swift
//  mecab-ios-sample
//
//  Created by Naoki Nakamura on 2019/10/04.
//  Copyright © 2019 Naoki Nakamura. Under MIT license.
//

import UIKit

let dictionaryURL = "https://dict.sohzoh.com/"
let dictionaryPart = "dict.sohzoh.com"


class ViewController: UIViewController, UITextViewDelegate {
    
    lazy var tokenizer = Tokenizer()
    let dictionaryManager = DictionaryManager()
    var passToCheckDictionary = true
    var lastTokens: [Token]? = nil
    var lastTermsFound = Set<String>()
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var outputTextArea: UITextView!
    
    let indentStyle = NSMutableParagraphStyle()
    let defaultAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 20.0), ]
    var surfaceAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 26.0)]
    lazy var tokenAttributes = TokenAttributerOptions(surfaceAttributes: [:], defaultAttributes:[:])
    
    @IBAction func tokenize() {
        if let text = inputField.text {
            // parse the text from inputField
            lastTokens = tokenizer.parse(text)
        }
        // hide the keyboard
        inputField.resignFirstResponder()
        updateText()
        dictionaryManager.searchTerms(tokens: lastTokens)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputTextArea.isSelectable = true
        outputTextArea.isEditable = false
        outputTextArea.delegate = self
        
        indentStyle.lineSpacing = 2.0
        surfaceAttributes.merge([.paragraphStyle: indentStyle], uniquingKeysWith: { _, new in new })
        tokenAttributes = TokenAttributerOptions(
            surfaceAttributes: surfaceAttributes, defaultAttributes: defaultAttributes)

        NotificationCenter.default.addObserver(forName: .termsFound, object: nil, queue: .main, using: { [weak self] notification in
            guard let termsFound = notification.object as? Set<String> else { return }
            self?.lastTermsFound = termsFound
            self?.updateText()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateText() {
        guard let tokens = lastTokens else { return }
        outputTextArea.attributedText = tokensToAttributedText(tokens: tokens, termsFound: lastTermsFound, attributes: tokenAttributes)
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (URL.pathComponents.contains(dictionaryPart)) {
            let libraryViewController = UIReferenceLibraryViewController.init(term: URL.lastPathComponent)
            self.present(libraryViewController, animated: true, completion: nil)
        }
        return false
    }
}


