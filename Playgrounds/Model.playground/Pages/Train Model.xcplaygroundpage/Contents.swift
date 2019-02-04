import Foundation
import CreateML
import NaturalLanguage
import PlaygroundSupport

// Constants
struct TrainingData {
    static let url = Bundle.main.url(forResource: "structured_data", withExtension: "json")!
    static let textColumnName = "text"
    static let labelColumnName = "label"
}

// Load training data
let data = try MLDataTable(contentsOf: TrainingData.url)

// Split data into 3 sets: training, validation and testing
let (extendedTrainingData, testingData) = data.randomSplit(by: 0.9, seed: 1)

var models: [(error: Double, model: MLTextClassifier)] = []
for seed in 0..<10 {
    let (trainingData, validationData) = extendedTrainingData.randomSplit(by: 0.9, seed: seed)
    
    // Choose between maximum entropy and conditional random fields
    let algorithm = MLTextClassifier.ModelAlgorithmType.maxEnt(revision: nil)
    
    // Specify training algorithm parameters
    let parameters = MLTextClassifier.ModelParameters(validationData: validationData, algorithm: algorithm, language: .english)
    
    // Treain a model
    let model = try MLTextClassifier(
        trainingData: trainingData,
        textColumn: TrainingData.textColumnName,
        labelColumn: TrainingData.labelColumnName,
        parameters: parameters)
    
    let evaluation = model.evaluation(on: testingData)
    print(evaluation)
    
    models.append((evaluation.classificationError, model))
}

// Write the model to url
if let model = models.sorted(by: { $0.error < $1.error }).first {
    print(model.error)
    try model.model.write(to: playgroundSharedDataDirectory.appendingPathComponent("HatredModel.mlmodel"))
}
