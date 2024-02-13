//
//  MealViewModel.swift
//  fetch-coding-test
//
//  Created by Rahul Vamusani on 2/12/24.
//

import Foundation
import SwiftUI

class MealViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var selectedMeal: Meal?
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    func fetchMeals(category: String) {
        NetworkManager.shared.fetchMeals(category: category) { result in
            switch result {
                
            case .success(let meals):
                DispatchQueue.main.async {
                    self.meals = meals
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "Error fetching meals: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchMealDetail(mealId: String) {
        NetworkManager.shared.fetchMealDetail(mealId: mealId) { result in
            switch result {
            case .success(let meals):
                DispatchQueue.main.async {
                    self.selectedMeal = meals.first
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: "Error fetching meals: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        self.alertMessage = message
        self.showAlert = true
    }
}
