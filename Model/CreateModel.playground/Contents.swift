import Foundation
import NaturalLanguage

let url = URL(string: "")!
let classifierModel = try! NLModel(contentsOf: url)

let prediction = classifierModel.predictedLabel(for: "bla")

import Foundation
import CreateML

let url = Bundle.main.url(forResource: "structured_data", withExtension: "json")!
let data = try MLDataTable(contentsOf: url)

let model = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "label")

try model.write(to: <YOUR_URL>)
