import Foundation
import CreateML

let url = Bundle.main.url(forResource: "structured_data", withExtension: "json")!
let data = try MLDataTable(contentsOf: url)

let model = try MLTextClassifier(trainingData: data, textColumn: "text", labelColumn: "label")

try model.write(to: URL(fileURLWithPath: "/Users/strv/Desktop/HatredModel.mlmodel"))
