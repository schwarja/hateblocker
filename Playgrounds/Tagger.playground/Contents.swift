import UIKit
import NaturalLanguage

enum NLError: Error {
    case unknownLanguage
}

let text = "I hate you so much!"
let recognizer = NLLanguageRecognizer()
recognizer.processString(text)

guard let language = recognizer.dominantLanguage else {
    throw NLError.unknownLanguage
}

language.rawValue

let unit: NLTokenUnit = .word
let schemes = NLTagger.availableTagSchemes(for: unit, language: language)
print(schemes.map({ $0.rawValue }))

let scheme: NLTagScheme = .language
let range = text.startIndex ..< text.endIndex
let tagger = NLTagger(tagSchemes: [scheme])
tagger.string = text

print(tagger.tags(in: range, unit: unit, scheme: scheme).compactMap({ $0.0?.rawValue }))
