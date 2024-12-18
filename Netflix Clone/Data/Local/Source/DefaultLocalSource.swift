//
//  LocalSourceImpl.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 17.12.2024.
//
import CoreData

class DefaultLocalSource: LocalSource {
    
    
    let manager: PersistenceManager!
    private var fetchResultsController: NSFetchedResultsController<MovieEntity>?
    
    init(){
        manager = PersistenceManager.shared
        //        clearAll()
    }
    
    func fetchDownloadedMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "isDownloaded == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            completion(.success(movies))
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    func fetchFavoritesMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ()) {
        
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            completion(.success(movies))
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    func fetchOnWatchlistMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "isOnWatchlist == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            completion(.success(movies))
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    func fetchTralierWatchedMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "tralierWatched == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            completion(.success(movies))
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    
    func updateDownloadStatus(movie: Movie, isDownload: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(movie.id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                entity.isDownloaded = isDownload
                completion(.success(()))
                print("Movie updated successfully!")
            } else {
                if isDownload{
                    let movieEntity = MovieEntity(context: manager.container.viewContext)
                    movieEntity.id = Int64(movie.id)
                    movieEntity.title = movie.title
                    movieEntity.name = movie.name
                    movieEntity.backdropPath = movie.backdropPath
                    movieEntity.posterPath = movie.posterPath
                    movieEntity.overview = movie.overview
                    movieEntity.voteAverage = movie.voteAverage
                    movieEntity.voteCount = Int64(movie.voteCount)
                    movieEntity.runtime = Int64(movie.runtime ?? 0)
                    movieEntity.releaseDate = movie.releaseDate
                    movieEntity.isDownloaded = true
                    print("Movie added successfully!")
                }
            }
            saveChanges()
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    func updateFavoriteStatus(movie: Movie, isFavorite: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(movie.id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                entity.isFavorite = isFavorite
                completion(.success(()))
                print("Movie updated successfully!")
            } else {
                let movieEntity = MovieEntity(context: manager.container.viewContext)
                movieEntity.id = Int64(movie.id)
                movieEntity.title = movie.title
                movieEntity.name = movie.name
                movieEntity.backdropPath = movie.backdropPath
                movieEntity.posterPath = movie.posterPath
                movieEntity.overview = movie.overview
                movieEntity.voteAverage = movie.voteAverage
                movieEntity.voteCount = Int64(movie.voteCount)
                movieEntity.runtime = Int64(movie.runtime ?? 0)
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.isFavorite = true
                print("Movie added successfully!")
            }
            saveChanges()
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    func updateWatchlistStatus(movie: Movie, inWatchList: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(movie.id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                entity.isOnWatchlist = inWatchList
                completion(.success(()))
                print("Movie updated successfully!")
            } else {
                let movieEntity = MovieEntity(context: manager.container.viewContext)
                movieEntity.id = Int64(movie.id)
                movieEntity.title = movie.title
                movieEntity.name = movie.name
                movieEntity.backdropPath = movie.backdropPath
                movieEntity.posterPath = movie.posterPath
                movieEntity.overview = movie.overview
                movieEntity.voteAverage = movie.voteAverage
                movieEntity.voteCount = Int64(movie.voteCount)
                movieEntity.runtime = Int64(movie.runtime ?? 0)
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.isOnWatchlist = inWatchList
                print("Movie added successfully!")
            }
            saveChanges()
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    func updateTralierWatchedStatus(movie: Movie, tralierWatched: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(movie.id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                entity.tralierWatched = tralierWatched
                completion(.success(()))
                print("Movie updated successfully!")
            } else {
                let movieEntity = MovieEntity(context: manager.container.viewContext)
                movieEntity.id = Int64(movie.id)
                movieEntity.title = movie.title
                movieEntity.name = movie.name
                movieEntity.backdropPath = movie.backdropPath
                movieEntity.posterPath = movie.posterPath
                movieEntity.overview = movie.overview
                movieEntity.voteAverage = movie.voteAverage
                movieEntity.voteCount = Int64(movie.voteCount)
                movieEntity.runtime = Int64(movie.runtime ?? 0)
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.tralierWatched = tralierWatched
                print("Movie added successfully!")
            }
            saveChanges()
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    
    func updateContinueWatchStatus(movie: Movie, tralierWatched: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(movie.id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                entity.continueWatched = tralierWatched
                completion(.success(()))
                print("Movie updated successfully!")
            } else {
                let movieEntity = MovieEntity(context: manager.container.viewContext)
                movieEntity.id = Int64(movie.id)
                movieEntity.title = movie.title
                movieEntity.name = movie.name
                movieEntity.backdropPath = movie.backdropPath
                movieEntity.posterPath = movie.posterPath
                movieEntity.overview = movie.overview
                movieEntity.voteAverage = movie.voteAverage
                movieEntity.voteCount = Int64(movie.voteCount)
                movieEntity.runtime = Int64(movie.runtime ?? 0)
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.continueWatched = tralierWatched
                print("Movie added successfully!")
            }
            saveChanges()
        } catch {
            completion(.failure(MovieError.localFetchError))
        }
    }
    
    
    func isDownloaded(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                return entity.isDownloaded
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    
    func isFavorite(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                return entity.isFavorite
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isOnWatchlist(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                return entity.isOnWatchlist
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isTralierWatched(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                return entity.tralierWatched
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isContinueToWatch(id: Int) -> Bool {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", Int64(id))
        fetchRequest.predicate = predicate
        
        do {
            let movies = try manager.container.viewContext.fetch(fetchRequest)
            if let entity = movies.first {
                
                return entity.continueWatched
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    
    func clearAll() {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try manager.container.viewContext.execute(deleteRequest)
            saveChanges()
        }
        catch {
            print ("There was an error")
        }
    }
    
    func saveChanges() {
        manager.saveContext(){ success , error in
            guard error == nil else {
                print("An error occurred while saving: \(error!)")
                return
            }
            guard success != nil else {
                print("Were saved")
                return
            }
        }
    }
}
