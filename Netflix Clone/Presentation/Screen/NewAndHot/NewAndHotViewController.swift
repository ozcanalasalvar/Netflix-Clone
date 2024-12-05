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
    private var centerCell : NewAndHotCollectionViewCell?
    private var tabbarHeightConsraint: NSLayoutConstraint!
    
    private let newAndHotCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewAndHotCollectionViewCell.self, forCellWithReuseIdentifier: NewAndHotCollectionViewCell.identifier)
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.centerCell?.playTralier()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        centerCell?.pauseTralier()
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
        
        tabbar.addSubview(categoryCollectionView)
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let barHeight = Constant.defaultTabbarHeight + Constant.tabBarItemHeight + 5 //For padding
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
            categoryCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(Constant.tabBarItemHeight)),
        ])
    }
    
    private func applyConsraints(){
        
        let tableConstraints = [
            newAndHotCollectionView.topAnchor.constraint(equalTo: tabbar.bottomAnchor),
            newAndHotCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        
    }
    
    func moviesFetchingFailed(error: String) {
        print(error)
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
            let width = category.title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 11, weight: .semibold)]).width + 20 
            
            let calculatedWidth = width + 20
            return CGSize(width: calculatedWidth, height: CGFloat(Constant.tabBarItemHeight))
        }else {
            return CGSize(width: UIScreen.main.bounds.width, height: 500) // Change height as needed
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == newAndHotCollectionView {
            collectionView.deselectItem(at: indexPath, animated: false)
            centerCell?.pauseTralier()
            self.navigateToPreview(with: newAndHots[indexPath.row].movie)
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
            let section = categories[indexPath.item].category
            viewModel.updateCategorySelection(section: section)
            
            if let firstVİsibleItemIndex = newAndHots.firstIndex(where: { $0.categoryType == section}) {
                let itemToScroll = newAndHots.index(after: firstVİsibleItemIndex)
                let indexPath = IndexPath(item: itemToScroll, section: 0)
                newAndHotCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
                
            }
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let view = scrollView as? UICollectionView else { return }
        if view == newAndHotCollectionView {
            videoPlayConfiguration()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            guard let view = scrollView as? UICollectionView else { return }
            if view == newAndHotCollectionView {
                videoPlayConfiguration()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let view = scrollView as? UICollectionView else { return }
        if view == newAndHotCollectionView {
            pauseVideoCells()
            guard let visibleIndex = newAndHotCollectionView.indexPathsForVisibleItems.first else  { return }
            viewModel.updateCategorySelection(section: newAndHots[visibleIndex.item].categoryType)
           
        }
    }
    
    
    func videoPlayConfiguration(){
        guard let visibleCells = newAndHotCollectionView.visibleCells as? [NewAndHotCollectionViewCell] else { return }
        
        for cell in visibleCells {
            let cellFrameInCollectionView = newAndHotCollectionView.convert(cell.frame, to: newAndHotCollectionView.superview)
            let collectionViewCenter = newAndHotCollectionView.center.y
            
            if cellFrameInCollectionView.midY > collectionViewCenter - cell.frame.height / 2 && cellFrameInCollectionView.midY < collectionViewCenter + cell.frame.height / 2 {
                centerCell = cell
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




