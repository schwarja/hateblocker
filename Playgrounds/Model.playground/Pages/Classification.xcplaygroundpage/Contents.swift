import Foundation
import NaturalLanguage

// Classifier classes
enum HateClass: String {
    case correct
    case offensive
    case hateful
}

// Compile mlmodel file to mlmodelc filesystem structure
let url = try! MLModel.compileModel(at: Model.url)
// Load a classification model from a mlmodelc directory
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
