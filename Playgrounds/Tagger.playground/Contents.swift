import UIKit
import NaturalLanguage
if #available(iOS 12, *) {
    let recognizer = NLLanguageRecognizer()
    recognizer.processString("I hate you so much")
    let language = recognizer.dominantLanguage
    language?.rawValue
    let schemes = NLTagger.availableTagSchemes(for: .word, language: language!)
    print(schemes.map({ $0.rawValue }))
}
