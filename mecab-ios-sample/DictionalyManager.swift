//
// Created by 中村直紀 on 2019/11/28.
// Copyright (c) 2019 Naoki Nakamura. Under MIT license.
//

import Foundation
import UIKit

extension Notification.Name {
    static let termsFound = Notification.Name("termsFound")
}

class DictionaryManager {
    func searchTerms(terms: [String]) {
        DispatchQueue.global(qos: .userInitiated).async {
            var foundTerms = Set<String>()
            terms.forEach{ term in
                if(UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: term)){
                    foundTerms.insert(term)
                }
            }
            NotificationCenter.default.post(name: .termsFound, object: foundTerms)
        }
    }

    func searchTerms(tokens: [Token]?) {
        guard let tokens = tokens else { return }
        let terms = tokens.compactMap { token in token.originalForm }
        searchTerms(terms: terms)
    }
}
