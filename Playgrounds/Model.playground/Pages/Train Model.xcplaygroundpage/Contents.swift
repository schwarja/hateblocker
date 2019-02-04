import Foundation
import CreateML
import NaturalLanguage

// Constants
struct TrainingData {
    static let url = Bundle.main.url(forResource: "structured_data", withExtension: "json")!
    static let textColumnName = "text"
    static let labelColumnName = "label"
}

// Load training data
let data = try MLDataTable(contentsOf: TrainingData.url)

// Split data into training and testing datasets
let (extendedTrainingData, testingData) = data.randomSplit(by: 0.9, seed: 1)

// Array of models with their errors
var models: [(error: Double, model: MLTextClassifier)] = []
for seed in 0..<10 {
    // Split training data into real training dataset and validation dataset
    let (trainingData, validationData) = extendedTrainingData.randomSplit(by: 0.9, seed: seed)
    
    // Choose between maximum entropy and conditional random fields
    let algorithm = MLTextClassifier.ModelAlgorithmType.maxEnt(revision: 1)
    
    // Specify training algorithm parameters
    let parameters = MLTextClassifier.ModelParameters(validationData: validationData, algorithm: algorithm, language: .english)
    
    // Treain a model
    let model = try MLTextClassifier(
        trainingData: trainingData,
        textColumn: TrainingData.textColumnName,
        labelColumn: TrainingData.labelColumnName,
        parameters: parameters)
    
    // Evaluate the trained model
    let evaluation = model.evaluation(on: testingData)
    print(evaluation)
    
    // Append trained model to the array of models
    models.append((evaluation.classificationError, model))
}

// Write the best model to url
if let model = models.sorted(by: { $0.error < $1.error }).first {
    try model.model.write(to: Model.url)
}
