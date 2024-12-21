//
//  MovieStore.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import Foundation


class MovieServiceImpl : MovieService{
  
    static let shared = MovieServiceImpl()
    private init() {}
    
        
    private let apiKey = "6cea5507c1dafd8f492d1d9a552483bc"
    private let baseAPIURL = "https://api.themoviedb.org/3/"
    private let googleApis_BaseUrl = "https://youtube.googleapis.com/"
    private let youtubeAPI_KEY = "AIzaSyC54d9CLxjDODINBaoIEBZWdqBSHkcJeJE"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    
    
    func fetchMovies(from endPoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)\(endPoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(url: url, completion: completion)
    
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<MovieData, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(url: url, params:[
            "append_to_response": "videos,credits"
        ],completion: completion)
    }
    
    
    
    func fetchTv(id: Int, completion: @escaping (Result<MovieData, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)tv/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(url: url, params:[
            "append_to_response": "videos,credits"
        ],completion: completion)
    }
    
    
    func fetchMovieSimilars(id: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)movie/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadUrlAndDecode(url: url, completion: completion)
    }
    
    func fetchTvSimilars(id: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)tv/\(id)/similar") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadUrlAndDecode(url: url, completion: completion)
    }
    
    
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)\(MovieListEndpoint.search.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        
        self.loadUrlAndDecode(url: url, params:[
            "language": "en-US",
            "include_adult": "false",
            "region":"US",
            "query":query
        ],completion: completion)
    }
    
    
    func discoverMovie(completion: @escaping (Result<MovieResponse,MovieError>) -> ()) {
        
        guard let url = URL(string: "\(baseAPIURL)\(MovieListEndpoint.discover.rawValue)") else {
             completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: [
                "language" : "en",
                "sort_by" : "popularity.desc",
                "include_adult" : "false",
                "include_video" : "false",
                "page" : "1",
                "with_watch_monetization_types" : "1",
            ],
            completion: completion)
    }
    
    func getTraliers(movieId: Int ,completion: @escaping (Result<MovieVideoResponse,MovieError>) -> ()) {
        
        guard let url = URL(string: "\(baseAPIURL)movie/\(movieId)/videos?language=en-US'") else {
             completion(.failure(.invalidEndpoint))
            return
        }
        
        self.loadUrlAndDecode(
            url: url,
            params: [
                "language" : "en-US",
            ],
            completion: completion)
    }
    
    private func loadUrlAndDecode<D : Decodable>(url : URL ,params: [String: String]? = nil, completion: @escaping (Result<D,MovieError>) -> ()){
        
        guard var urlComponents = URLComponents(url:url , resolvingAgainstBaseURL: false) else {
            completion(.failure(MovieError.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params{
            queryItems.append(contentsOf: params.map{URLQueryItem(name: $0.key, value: $0.value)})
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        print(finalURL)
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if(error != nil){
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                completion(.failure(.apiError))
                return
                
            }
            
            guard let httpResponse  = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            
            guard let data = data else{
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse  = try self.jsonDecoder.decode(D.self, from: data)
                //print(decodedResponse)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
            
        }.resume()
                
    }
    
    
    private func executeCompletionHandlerInMainThread<D : Decodable>(with result : Result<D,MovieError>, completion : @escaping (Result<D,MovieError>) -> ()){
        
        //this block switch my ıo thread to main thread
        DispatchQueue.main.async {
            completion(result)
        }
    }
}
