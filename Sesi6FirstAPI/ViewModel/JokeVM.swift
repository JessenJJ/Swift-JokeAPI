//
//  JokeVM.swift
//  Sesi6FirstAPI
//
//  Created by User50 on 19/04/24.
//

import Foundation

/// Main actor digunakan untuk memastikan semua background process dapat berlangsung bersamaan dengan proses UI atau interaksi user dengan aplikasi
@MainActor
class JokeVM: ObservableObject {
    @Published var joke: Joke?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchJoke() async {
        // set loading saat ambil data
        isLoading = true
        // set error 
        errorMessage = nil
        do {
            joke = try await APIService.shared.fetchJokeServices()
            print("Setup: \(joke?.setup ?? "No Setup")")
            print("Punchline: \(joke?.punchline ?? "No punchline" )")
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("😭 ERROR: Could not get data from URL: \(Constants.jokeAPI).\(error.localizedDescription)")
        }
    }
}
