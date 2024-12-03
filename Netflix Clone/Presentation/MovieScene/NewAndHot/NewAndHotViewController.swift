//
//  UpComingViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class NewAndHotViewController: UIViewController{
    
    
    private var upComimgs: [Movie] = []
    
    var centerCell : NewAndHotCollectionViewCell?
    
    
    private var tabbarHeightConsraint: NSLayoutConstraint!
    
    private let newAndHotCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 500) // Change height as needed
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewAndHotCollectionViewCell.self, forCellWithReuseIdentifier: NewAndHotCollectionViewCell.identifier)
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let tabbar : TabbarView = {
        let tabbar = TabbarView()
        tabbar.backgroundColor = .systemBackground
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(newAndHotCollectionView)
        view.addSubview(tabbar)
        
        newAndHotCollectionView.dataSource = self
        newAndHotCollectionView.delegate = self
        
        
        configureTabbar()
        fetchUpcomings()
        applyConsraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInitialFrameOfTabbar()
    }
    
    var initialFrameSetted : Bool = false
    
    func setInitialFrameOfTabbar(){
        if initialFrameSetted{ return }
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tabbar.setTopPadding(statusbarHeight)
        tabbarHeightConsraint.constant =  statusbarHeight +  CGFloat(75)
        initialFrameSetted = true
    }
    
    private func configureTabbar(){
        
        let searchButton  = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTapGesture {
            print("searchButton")
        }
        
        let downloadButoon  = UIButton()
        downloadButoon.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        downloadButoon.tintColor = .white
        downloadButoon.addTapGesture {
            print("downloadButoon")
        }
        
        let shareButton  = UIButton()
        shareButton.setImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        shareButton.tintColor = .white
        
        downloadButoon.addTapGesture {
            print("downloadButoon")
        }
        let buttons: [UIButton] = [searchButton, downloadButoon, shareButton]
        
        tabbar.configure("New & Hot", icons: buttons)
    }
    
    private func applyConsraints(){
        
        let tableConstraints = [
            newAndHotCollectionView.topAnchor.constraint(equalTo: tabbar.bottomAnchor),
            newAndHotCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            newAndHotCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newAndHotCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let defaultBarHeight = 75
        let tabbarHeight = statusbarHeight + CGFloat(defaultBarHeight)
        tabbarHeightConsraint = tabbar.heightAnchor.constraint(equalToConstant: tabbarHeight)
        
        let tabbarConstarints = [
            tabbar.topAnchor.constraint(equalTo: view.topAnchor),
            tabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabbarHeightConsraint!
        ]
        
        NSLayoutConstraint.activate(tableConstraints)
        NSLayoutConstraint.activate(tabbarConstarints)
    }
    
    
    
    private func fetchUpcomings(){
        MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.upComing) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                upComimgs.removeAll()
                upComimgs = response.results
                DispatchQueue.main.async { [weak self] in
                    self?.newAndHotCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
    
}



extension NewAndHotViewController: UICollectionViewDataSource, UICollectionViewDelegate, NewAndHotCollectionViewCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upComimgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAndHotCollectionViewCell.identifier, for: indexPath) as? NewAndHotCollectionViewCell else { return UICollectionViewCell()}
        
        cell.configure(with: upComimgs[indexPath.row])
        cell.delegate = self
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        self.navigationController?.navigateToPreview(with: upComimgs[indexPath.row])
    }
        
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        videoPlayConfiguration()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            videoPlayConfiguration()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pauseVideoCells()
    }
    
    
    func videoPlayConfiguration(){
        guard let visibleCells = newAndHotCollectionView.visibleCells as? [NewAndHotCollectionViewCell] else { return }
        
        for cell in visibleCells {
            let cellFrameInCollectionView = newAndHotCollectionView.convert(cell.frame, to: newAndHotCollectionView.superview)
            let collectionViewCenter = newAndHotCollectionView.center.y
            
            if cellFrameInCollectionView.midY > collectionViewCenter - cell.frame.height / 2 && cellFrameInCollectionView.midY < collectionViewCenter + cell.frame.height / 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cell.playTralier()
                }
                
            } else {
                cell.pauseTralier()
            }
        }
    }
    
    
    func pauseVideoCells(){
        guard let visibleCells = newAndHotCollectionView.visibleCells as? [NewAndHotCollectionViewCell] else { return }
        
        for cell in visibleCells {
            let cellFrameInCollectionView = newAndHotCollectionView.convert(cell.frame, to: newAndHotCollectionView.superview)
            let collectionViewCenter = newAndHotCollectionView.center.y
            
            if cellFrameInCollectionView.midY > collectionViewCenter - cell.frame.height / 2 && cellFrameInCollectionView.midY < collectionViewCenter + cell.frame.height / 2 {
                
            } else {
                cell.pauseTralier()
            }
        }
    }
    
    
    func newAndHotCollectionViewCellDidTapSound(_ cell: NewAndHotCollectionViewCell, isMuted: Bool) {
        newAndHotCollectionView.visibleCells.forEach { cell in
            (cell as? NewAndHotCollectionViewCell)?.isMuted = isMuted
        }
    }
    
    
}




