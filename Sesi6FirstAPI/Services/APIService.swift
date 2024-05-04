//
//  APIService.swift
//  Sesi6FirstAPI
//
//  Created by User50 on 19/04/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchJokeServices() async throws -> Joke {
        // Memastikan url dengan sumber url yang diinginkan
        let urlString = URL(string: Constants.jokeAPI)
        // Memastikan url sesuai dengan kaidah url yang baik
        guard let url = urlString else {
            print("Hang woi ERROR: Cok 🤬 Cannot convert \(String(describing: urlString)) to a URL")
            throw URLError(.badURL)
        }
        // Memberi tahu bahwa url dapat diakses
        print("🕸️ We are accessing the url \(url)")
        
        // Mengambil data dan response dari url menggunakan try await untuk mencoba dan menunggu proses
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Memastikan terdapat response dari api atau tidak
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Memastikan response tersebut 200 - 299 sehingga success
        guard (200...299).contains(httpResponse.statusCode)else{
            throw URLError(.init(rawValue: httpResponse.statusCode))
        }
        
        // Jika tidak error responsenya maka lakukan decode dari bentuk json ke object decodable coding
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        
        // Mengembalikan hasil decode
        return joke
        
    }
}

/// Kenapa pakai class?
/// 1. untuk memastikan bahwa hanya ada satu object (instance) bersama (shared) yang akan digunakan di seluruh aplikasi. Konsep ini disebut dengan Singleton
///
/// 2. Jadi, nanti setiap ada perubahan State di bagian lain dari aplikasi kita, statenya akan sama. Seperti konsep mobil yang diubah warna tadi.
///
/// 3. Cara pemanggilannya, APIService.shared
///
/// 4. Untuk mencegah agar si object APIService tidak di re-create diluar kelas ini
