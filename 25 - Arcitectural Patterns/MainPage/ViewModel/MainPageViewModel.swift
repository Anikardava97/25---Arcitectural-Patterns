//
//  MainPageViewModel.swift
//  25 - Arcitectural Patterns
//
//  Created by Ani's Mac on 17.11.23.
//

import UIKit

class MoviesViewModel {
    private var movies = [Movie]()
    
    var numberOfMovies: Int {
        return movies.count
    }
    
    func movieAtIndex(_ index: Int) -> Movie {
        return movies[index]
    }
    
    func fetchMovies(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.fetchMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedMovies):
                    self?.movies = fetchedMovies
                    completion(true)
                case .failure(_):
                    completion(false)
                }
            }
        }
    }
    
    func loadImage(for movie: Movie, completion: @escaping (UIImage?) -> Void) {
        guard let posterPath = movie.posterPath else {
            completion(nil)
            return
        }
        
        NetworkManager.shared.downloadImage(from: posterPath, completion: completion)
    }
}

