//
//  TokenAttributer.swift
//  mecab-ios-sample
//
//  Created by 中村直紀 on 2019/12/21.
//  Copyright © 2019 Naoki Nakamura. Under MIT license.
//

import Foundation
import UIKit

struct TokenAttributerOptions {
    let surfaceAttributes: [NSAttributedString.Key: Any]
    let defaultAttributes: [NSAttributedString.Key: Any]
    let undefinedSymbol = "-"
    let labelReading = NSLocalizedString("Reading:", comment: "")
    let labelOriginal = NSLocalizedString("Original Form:", comment: "")
    let labelInflection = NSLocalizedString("Inflextion:", comment: "")
    let labelPartsOfSpeech = NSLocalizedString("Part of Speech:", comment: "")
    let labelSeparator = NSLocalizedString(", ", comment: "")
    
    init(surfaceAttributes: [NSAttributedString.Key: Any], defaultAttributes: [NSAttributedString.Key: Any]) {
        self.surfaceAttributes = surfaceAttributes
        self.defaultAttributes = defaultAttributes
    }
}

func tokensToAttributedText(tokens: [Token], termsFound: Set<String> = [], attributes attr: TokenAttributerOptions) -> NSAttributedString {

    let attributedText = NSMutableAttributedString()
    for token in tokens {
        // all tokens have a surface property (the exact substring)
        attributedText.append(NSAttributedString(
            string: "\(token.surface)\n", attributes: attr.surfaceAttributes))

        // but the other properties aren't required, so they're optional
        let reading = token.reading?.applyingTransform(.hiraganaToKatakana, reverse: true)
        if let reading = reading {
            attributedText.append(NSAttributedString(
                string: "\(attr.labelReading) \(reading)\n", attributes: attr.defaultAttributes))
        }

        if let originalForm = token.originalForm {
            attributedText.append(NSAttributedString(string: "\(attr.labelOriginal) ", attributes: attr.defaultAttributes))
            if termsFound.contains(originalForm) {
                let url = URL(fileURLWithPath: dictionaryURL).appendingPathComponent(originalForm)
                let linkedAttributes = attr.defaultAttributes.merging([NSAttributedString.Key.link: url],
                        uniquingKeysWith: { _, new in new })

                attributedText.append(NSAttributedString(
                        string: "\(originalForm)\n",
                        attributes: linkedAttributes))
            } else {
                attributedText.append(NSAttributedString(
                        string: "\(originalForm)\n",
                        attributes: attr.defaultAttributes))
            }
        }
        
        if let inflextion = token.inflection {
            attributedText.append(NSAttributedString(
                string: "\(attr.labelInflection) \(inflextion)\n", attributes: attr.defaultAttributes))
        }
        attributedText.append(NSAttributedString(
                string: "\(attr.labelPartsOfSpeech) \(token.partsOfSpeech.joined(separator: attr.labelSeparator))\n\n",
                attributes: attr.defaultAttributes))
    }
    return attributedText
}
