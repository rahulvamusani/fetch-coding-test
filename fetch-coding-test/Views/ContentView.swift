//
//  ContentView.swift
//  fetch-coding-test
//
//  Created by Rahul Vamusani on 2/12/24.
//

import SwiftUI
struct ContentView: View {
    @StateObject var viewModel = MealViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.meals) { meal in
                NavigationLink(destination: MealDetailView(mealId: meal.idMeal)) {
                    Text(meal.strMeal)
                }
            }
            .navigationTitle("Dessert Recipes")
            .onAppear {
                viewModel.fetchMeals(category: "Dessert")
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
