import Foundation
import NaturalLanguage

// Classifier classes
enum HateClass: String {
    case correct
    case offensive
    case hateful
}

// Load a classification model from a file
let url = Bundle.main.url(forResource: "HatredModel", withExtension: "mlmodelc")!
let classifier = try! NLModel(contentsOf: url)


/// Classify given text
///
/// - Parameter text: Text that should be classified
/// - Returns: Resulting class or nil if the classifier can't classify the given text
func evaluate(text: String) -> HateClass? {
    if let prediction = classifier.predictedLabel(for: text),
        let hateClass = HateClass(rawValue: prediction) {
        return hateClass
    }

    return nil
}

evaluate(text: "iOS rules")
