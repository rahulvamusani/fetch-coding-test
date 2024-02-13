//
//  NetworkManager.swift
//  fetch-coding-test
//
//  Created by Rahul Vamusani on 2/12/24.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()

    private let baseUrl = "https://themealdb.com/api/json/v1/1/"

    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }

    func fetchMeals(category: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        let endpoint = baseUrl + "filter.php?c=\(category)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.noData))
                return
            }

            do {
                let response = try JSONDecoder().decode(MealCategoryResponse.self, from: data)
                completion(.success(response.meals))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }

    func fetchMealDetail(mealId: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        let endpoint = baseUrl + "lookup.php?i=\(mealId)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NetworkError.noData))
                return
            }

            do {
                let response = try JSONDecoder().decode(MealDetailResponse.self, from: data)
                completion(.success(response.meals))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}
