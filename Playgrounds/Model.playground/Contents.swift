import Foundation
import CreateML
import NaturalLanguage

let url = Bundle.main.url(forResource: "structured_data", withExtension: "json")!
let data = try MLDataTable(contentsOf: url)

let algorithm = MLTextClassifier.ModelAlgorithmType.maxEnt(revision: 1)
let parameters = MLTextClassifier.ModelParameters(validationData: [:], algorithm: algorithm, language: .english)
let model = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "label", parameters: parameters)

try model.write(to: URL(fileURLWithPath: "/Users/strv/Desktop/HatredModel-MaxEnt.mlmodel"))
