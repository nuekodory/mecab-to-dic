//
//  Tokenizer.swift
//  mecab-ios-sample
//
//  Created by Landon Epps on 2018/04/13.
//  Copyright © 2018 Landon Epps. All rights reserved.
//

import Foundation

/**
 A struct that represents a mecab node.
 
 nil is used instead of "*" (MeCab's convention) to represent a non-exsistent feature
*/
struct Token {
    /// the exact token from the text (表層形)
    let surface: String
    /// the raw feature string from MeCab ("品詞, 品詞細分類1, 品詞細分類2, 品詞細分類3, 活用形, 活用型, 原形, 読み, 発音")
    let feature: String
    /// an array representation of MeCab's feature string ("品詞, 品詞細分類1, 品詞細分類2, 品詞細分類3, 活用形, 活用型, 原形, 読み, 発音")
    let features: [String]
    /// the main part of speech (品詞)
    let partOfSpeech: String?
    /// an array including the main part of speech and any subtypes (品詞, 品詞細分類1, ...)
    let partsOfSpeech: [String]
    /// the inflection of the word (活用形)
    let inflection: String?
    /// the type of inflection (活用型)
    let inflectionType: String?
    /// the uninflected form of the token (原形)
    let originalForm: String?
    /// the reading of the token (読み)
    let reading: String?
    /// the pronunciation of the token (発音)
    let pronunciation: String?
}

/**
 A Swift wrapper for MeCab.
 
 Provides a simple function, parse(), to break a String into tokens.
*/
class Tokenizer {
    /// the original Objective-C MeCab wrapper
    let mecab = Mecab()
    
    /**
     Parses a string with MeCab, and returns an array of Tokens.
     
     - parameter text: The String to be parsed.
     - returns: An array of Tokens. Each token represents a MeCab node.
    */
    func parse(text: String) -> [Token] {
        /// array of tokens to be returned
        var tokens = [Token]()
        if let nodes = mecab.parseToNode(with: text) as? [Node] {
            for node in nodes {
                /// an array representation of the parts of speech
                var partsOfSpeech = [String]()
                if let pos = node.partOfSpeech(), pos != "*" {
                    partsOfSpeech.append(pos)
                }
                if let pos1 = node.partOfSpeechSubtype1(), pos1 != "*" {
                    partsOfSpeech.append(pos1)
                }
                if let pos2 = node.partOfSpeechSubtype2(), pos2 != "*" {
                    partsOfSpeech.append(pos2)
                }
                if let pos3 = node.partOfSpeechSubtype3(), pos3 != "*" {
                    partsOfSpeech.append(pos3)
                }
                
                // create a new token to be added to tokens
                let newToken = Token(surface: node.surface,
                     feature: node.feature,
                     features: node.features as! [String],
                     partOfSpeech: node.partOfSpeech() != "*" ? node.partOfSpeech() : nil,
                     partsOfSpeech: partsOfSpeech,
                     inflection: node.inflection() != "*" ? node.inflection() : nil,
                     inflectionType: node.useOfType() != "*" ? node.useOfType() : nil,
                     originalForm: node.originalForm() != "*" ? node.originalForm() : nil,
                     reading: node.reading() != "*" ? node.reading() : nil,
                     pronunciation: node.pronunciation() != "*" ? node.pronunciation() : nil)
                tokens.append(newToken)
            }
        }
        return tokens
    }
}