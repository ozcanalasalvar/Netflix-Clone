//
//  UpComingViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class NewAndHotViewController: UIViewController{
    
    private var viewModel: NewAndHotViewModel!
    private var newAndHots: [MovieUiModel] = []
    private var categories: [NewHotCategory] = []
    private var tabbarHeightConsraint: NSLayoutConstraint!
    
    private var isMuted: Bool = true
    // Track the currently playing video
    private var currentlyPlayingIndexPath: IndexPath? = nil
    
    private let newAndHotCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewAndHotCollectionViewCell.self, forCellWithReuseIdentifier: NewAndHotCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let categoryCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
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
        
        viewModel = NewAndHotViewModel()
        viewModel.delegate = self
        
        newAndHotCollectionView.dataSource = self
        newAndHotCollectionView.delegate = self
        
        configureTabbar()
        applyConsraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInitialFrameOfTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.playPlayerIndexAt(self?.currentlyPlayingIndexPath)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pausePlayerIndexAt(currentlyPlayingIndexPath)
    }

    
    var initialFrameSetted : Bool = false
    
    func setInitialFrameOfTabbar(){
        if initialFrameSetted{ return }
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tabbar.setTopPadding(statusbarHeight)
        tabbarHeightConsraint.constant =  statusbarHeight + tabbarHeightConsraint.constant
        initialFrameSetted = true
    }
    
    private func configureTabbar(){
        
        let searchButton  = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTapGesture {
            let controller = SearchResultViewController()
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
        let downloadButoon  = UIButton()
        downloadButoon.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        downloadButoon.tintColor = .white
        downloadButoon.addTapGesture {
            self.tabBarController?.selectedIndex = 2
        }
        
        let shareButton  = UIButton()
        shareButton.setImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        shareButton.tintColor = .white
        
        shareButton.addTapGesture {
            print("downloadButoon")
        }
        let buttons: [UIButton] = [searchButton, downloadButoon, shareButton]
        
        tabbar.configure("New & Hot", icons: buttons)
        
        tabbar.addSubview(categoryCollectionView)
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let barHeight = ViewConstant.defaultTabbarHeight + ViewConstant.tabBarItemHeight + 5 //For padding
        let tabbarHeight = statusbarHeight + CGFloat(barHeight)
        tabbarHeightConsraint = tabbar.heightAnchor.constraint(equalToConstant: tabbarHeight)
        
        let tabbarConstarints = [
            tabbar.topAnchor.constraint(equalTo: view.topAnchor),
            tabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabbarHeightConsraint!
        ]
        
        NSLayoutConstraint.activate(tabbarConstarints)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            categoryCollectionView.bottomAnchor.constraint(equalTo: tabbar.bottomAnchor, constant: -5),
            categoryCollectionView.leadingAnchor.constraint(equalTo: tabbar.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: tabbar.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(ViewConstant.tabBarItemHeight)),
        ])
    }
    
    private func applyConsraints(){
        
        let tableConstraints = [
            newAndHotCollectionView.topAnchor.constraint(equalTo: tabbar.bottomAnchor),
            newAndHotCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            newAndHotCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newAndHotCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(tableConstraints)
    }
    
}


extension NewAndHotViewController : NewAndHotViewModelOutput {
    func categoryUpdated(categories: [NewHotCategory]) {
        self.categories.removeAll()
        self.categories = categories
        
        DispatchQueue.main.async { [weak self] in
            self?.categoryCollectionView.reloadData()
        }
        
        if let itemToScrollTo = categories.firstIndex(where: { $0.selected }) {
            let indexPath = IndexPath(item: itemToScrollTo, section: 0)
            categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.playPlayerIndexAt(self?.currentlyPlayingIndexPath)
        })
    }
    
    
    func moviesFetched(categories: [NewHotCategory], movies: [MovieUiModel]) {
        newAndHots.removeAll()
        newAndHots = movies
        
        self.categories.removeAll()
        self.categories = categories
        DispatchQueue.main.async { [weak self] in
            self?.newAndHotCollectionView.reloadData()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.categoryCollectionView.reloadData()
        }
        
        currentlyPlayingIndexPath =  IndexPath(row: 0, section: 0)
    }
    
    func moviesFetchingFailed(error: String) {
        self.showNetworkErrorAlert(with: error)
    }
    
    
}


extension NewAndHotViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NewAndHotCollectionViewCellDelegate {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == newAndHotCollectionView {
            return newAndHots.count
        }
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == newAndHotCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAndHotCollectionViewCell.identifier, for: indexPath) as? NewAndHotCollectionViewCell else { return UICollectionViewCell()}
            cell.isMuted = isMuted
            cell.configure(with: newAndHots[indexPath.row].movie)
            cell.delegate = self
            return  cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            cell.configure(categories[indexPath.row])
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let category = categories[indexPath.row] 
            let width = category.title.toViewWidth(font: UIFont.systemFont(ofSize: 11, weight: .semibold)) + 20 
            
            let calculatedWidth = width + 20
            return CGSize(width: calculatedWidth, height: CGFloat(ViewConstant.tabBarItemHeight))
        }else {
            return CGSize(width: UIScreen.main.bounds.width, height: 500) // Change height as needed
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newAndHotCollectionView {
            collectionView.deselectItem(at: indexPath, animated: false)
            pausePlayerIndexAt(currentlyPlayingIndexPath)
            self.navigateToPreview(with: newAndHots[indexPath.row].movie)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
            let section = categories[indexPath.item].category
            viewModel.updateCategorySelection(section: section)
            
            if let firstVİsibleItemIndex = newAndHots.firstIndex(where: { $0.categoryType == section}) {
                let itemToScroll = newAndHots.index(after: firstVİsibleItemIndex-1)
                let indexPath = IndexPath(item: itemToScroll, section: 0)
                newAndHotCollectionView.scrollToItem(at: indexPath, at: .top, animated: true)
                viewModel.loadVideoForIndexedCell(index: indexPath.item)
            }
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let view = scrollView as? UICollectionView else { return }
        if view == newAndHotCollectionView {
            self.playPlayerIndexAt(self.currentlyPlayingIndexPath)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            guard let view = scrollView as? UICollectionView else { return }
            if view == newAndHotCollectionView {
                self.playPlayerIndexAt(self.currentlyPlayingIndexPath)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let view = scrollView as? UICollectionView else { return }
        if view == newAndHotCollectionView {
            //pauseOffCenterPlayers()
            findCenterCell()
            guard let visibleIndex = newAndHotCollectionView.indexPathsForVisibleItems.first else  { return }
            viewModel.updateCategorySelection(section: newAndHots[visibleIndex.item].categoryType)
           
        }
    }
    
    
    func newAndHotCollectionViewCellDidTapSound(_ cell: NewAndHotCollectionViewCell, isMuted: Bool) {
        newAndHotCollectionView.visibleCells.forEach { cell in
            (cell as? NewAndHotCollectionViewCell)?.isMuted = isMuted
            self.isMuted = isMuted
        }
    }
    
    
}



extension NewAndHotViewController {
    
    func findCenterCell(){

        guard newAndHotCollectionView.visibleCells is [NewAndHotCollectionViewCell] else { return }
        
        let visibleIndexPaths = newAndHotCollectionView.indexPathsForVisibleItems
        
        for indexPath in visibleIndexPaths {
            if let cell = newAndHotCollectionView.cellForItem(at: indexPath)  as? NewAndHotCollectionViewCell {
                // Get the frame of the cell in the collection view
                let cellFrame = newAndHotCollectionView.convert(cell.frame, to: newAndHotCollectionView.superview)
                let collectionViewCenter = newAndHotCollectionView.center.y
                
                if currentlyPlayingIndexPath != indexPath {
                    if cellFrame.midY > collectionViewCenter - cell.frame.height / 2 && cellFrame.midY < collectionViewCenter + cell.frame.height / 2 {
                        viewModel.loadVideoForIndexedCell(index : indexPath.item)
                        currentlyPlayingIndexPath = indexPath
                    } else {
                        cell.pauseTralier()
                    }
                    cell.isMuted = self.isMuted
                }
            }
        }
    }
    
    
    func pauseOffCenterPlayers(){
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
    
    
    func pausePlayerIndexAt(_ indexPath : IndexPath?){
        if let path = indexPath {
            if let cell = newAndHotCollectionView.cellForItem(at: path)  as? NewAndHotCollectionViewCell {
                cell.pauseTralier()
            }
        }
    }
    
    func playPlayerIndexAt(_ indexPath : IndexPath?){
        if let path = indexPath {
            if let cell = newAndHotCollectionView.cellForItem(at: path)  as? NewAndHotCollectionViewCell {
                cell.playTralier()
            }
        }
    }
    
    func updatePlayer(){
        // Get the center point of the collection view
        let centerPoint = CGPoint(x: newAndHotCollectionView.contentOffset.x + newAndHotCollectionView.bounds.size.width / 2,
                                  y: newAndHotCollectionView.contentOffset.y + newAndHotCollectionView.bounds.size.height / 2)
        
        // Get the index paths of all visible cells
        let visibleIndexPaths = newAndHotCollectionView.indexPathsForVisibleItems
        
        var closestCellIndexPath: IndexPath?
        var closestDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        
        // Loop through all visible cells to find the closest to the center
        for indexPath in visibleIndexPaths {
            if let cell = newAndHotCollectionView.cellForItem(at: indexPath) {
                let cellFrame = newAndHotCollectionView.convert(cell.frame, to: newAndHotCollectionView.superview)
                let cellCenter = CGPoint(x: cellFrame.origin.x + cellFrame.size.width / 2,
                                         y: cellFrame.origin.y + cellFrame.size.height / 2)
                let distance = hypot(centerPoint.x - cellCenter.x, centerPoint.y - cellCenter.y)
                
                if distance < closestDistance {
                    closestDistance = distance
                    closestCellIndexPath = indexPath
                }
            }
        }
        
        // Play the video in the closest centered cell and pause others
        if let indexPath = closestCellIndexPath {
            if currentlyPlayingIndexPath != indexPath {
                // Pause the currently playing video
                if let currentlyPlayingIndexPath = currentlyPlayingIndexPath,
                   let currentCell = newAndHotCollectionView.cellForItem(at: currentlyPlayingIndexPath) as? NewAndHotCollectionViewCell {
                    currentCell.pauseTralier()
                }
                
                // Play the new centered video
                if let cell = newAndHotCollectionView.cellForItem(at: indexPath) as? NewAndHotCollectionViewCell {
                    cell.playTralier()
                    viewModel.loadVideoForIndexedCell(index : indexPath.item)
                }
                
                // Update the currently playing video
                currentlyPlayingIndexPath = indexPath
            }
        }
    }
}

