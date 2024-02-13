//
//  MealDetailView.swift
//  fetch-coding-test
//
//  Created by Rahul Vamusani on 2/12/24.
//
import SwiftUI

struct MealDetailView: View {
    var mealId: String
    @StateObject var viewModel = MealViewModel()
    @State private var showAlert: Bool = false
    
    var body: some View {
        ScrollView {
            if let meal = viewModel.selectedMeal {
                
                let ingredientsArray: [String] = (1...20)
                    .compactMap { index in
                        let ingredientKey = "strIngredient\(index)"
                        let measureKey = "strMeasure\(index)"
                        
                        guard let ingredient = value(for: ingredientKey, in: meal) as? String, !ingredient.isEmpty,
                              let measure = value(for: measureKey, in: meal) as? String
                        else {
                            return nil
                        }
                        
                        return "\(ingredient): \(measure)"
                    }
                
                let ingredientsSet = Set(ingredientsArray)
                
                VStack {
                    Text(meal.strMeal)
                        .font(.title)
                    
                    AsyncImage(url: URL(string: meal.strMealThumb)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                    
                    Text("Instructions")
                        .font(.title)
                        .padding()
                    
                    Text(meal.strInstructions?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                    
                    Text("Ingredients")
                        .font(.title)
                        .padding()
                    ForEach(ingredientsSet.sorted(), id: \.self) { ingredient in
                        Text("\(ingredient)")
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.fetchMealDetail(mealId: mealId)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        .onChange(of: viewModel.showAlert) { newShowAlertValue in
            showAlert = newShowAlertValue
        }
    }
    
    private func value(for key: String, in meal: Meal) -> Any? {
        let mirror = Mirror(reflecting: meal)
        for child in mirror.children {
            if let label = child.label, label == key {
                return child.value
            }
        }
        return nil
    }
}
