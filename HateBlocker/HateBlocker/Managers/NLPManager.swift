//
//  NLPManager.swift
//  HateBlocker
//
//  Created by Jan on 10/06/2018.
//  Copyright © 2018 STRV s.r.o. All rights reserved.
//

import Foundation
import NaturalLanguage

class NLPManager {
    enum HateClass: String {
        case correct
        case offensive
        case hateful
    }
    
    // MARK: NLTagger
    private let hatefulLemmas: [NLLanguage: [String]] = [
        .english: ["hate"],
        .german: ["hassen"],
        .portuguese: ["odiar"]
    ]
    
    func hatefulRanges(in text: String) -> [Range<String.Index>] {
        let languageRecognizer = NLLanguageRecognizer()
        languageRecognizer.processString(text)
        guard let language = languageRecognizer.dominantLanguage else {
            return []
        }
        
        let lemmas = hatefulLemmas[language] ?? []
        let range = text.startIndex ..< text.endIndex
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = text

        let tags = tagger.tags(in: range, unit: .word, scheme: .lemma, options: [.omitWhitespace, .omitPunctuation])
        return tags.filter({ lemmas.contains($0.0?.rawValue ?? "") }).map{ $0.1 }
    }
    
    // MARK: Text Classifier
    private lazy var classifier: NLModel = {
        let url = Bundle.main.url(forResource: "HatredModel", withExtension: "mlmodelc")!
        return try! NLModel(contentsOf: url)
    }()
    
    func evaluate(text: String) -> HateClass? {
        if let prediction = classifier.predictedLabel(for: text),
            let hateClass = HateClass(rawValue: prediction) {
            return hateClass
        }

        return nil
    }
}
