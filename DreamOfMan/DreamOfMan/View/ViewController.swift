//
//  ViewController.swift
//  DreamOfMan
//
//  Created by jikichi on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let dataSource = DreamOfManDataSource()
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.dimsBackgroundDuringPresentation = false
        sc.searchBar.tintColor = UIColor.init(hex: "4D4D4D")
        sc.searchBar.sizeToFit()
        sc.searchBar.isTranslucent = false
        sc.searchBar.delegate = self
        return sc
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(AvgleSearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AvgleSearchResultsCollectionViewCell.self))
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.delegate = nil
        collectionView.dataSource = nil
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let api = AvgleAPI()
        api.getVideo(urlString: "https://avgle.com/video/vGZSDSWz1S1/fc2真實素人精選-好像是fc2的常客-熟悉的中出最對味")
        bindCollectionView()
        configureKeyboardDismissesOnScroll()
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .black
        collectionView.backgroundColor = UIColor.init(hex: "332E33")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: ((UIScreen.main.bounds.width * 0.9) * 9.0 / 16) + 40)
        layout.minimumLineSpacing = 20
        return layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "ポケモンずかん"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font : UIFont.boldSystemFont(ofSize: 26.0)
        ]
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black

        
        
        
        navigationItem.searchController = searchController
        
        navigationItem.searchController?.searchBar.searchTextField.backgroundColor = UIColor.init(hex: "332F2E")
        navigationItem.searchController?.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "ポケモンのなまえでけんさく", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(hex: "999999")])
    }
    
}

extension ViewController {
    private func bindCollectionView() {
        
        let API = AvgleAPI()
        
        let videosObservable = searchController.searchBar.rx.incrementalText
            .flatMap { text -> Observable<[Video]> in
                guard let text = text else { return .just([])}
                if text == "" { return API.getAllVideos()}
                return API.getSearchVideo(query: text)
            }
        
        videosObservable
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        videosObservable
//            .bind(to: collectionView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
        
        collectionView.rx
            .modelSelected(Video.self)
            .asDriver()
            .drive(onNext: { [weak self] model in
                
                let urlString = model.videoURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                guard let url = NSURL(string: urlString!) else {
                    print("can not found URL")
                    return
                }
                let viewModel = AvgleWebViewModel(url: url as URL)
                let nextViewController = AvgleWebViewController(viewModel: viewModel, url: url as URL)
                self?.navigationController?.pushViewController(nextViewController, animated: true)
            }).disposed(by: disposeBag)

    }
    
    private func configureKeyboardDismissesOnScroll() {
        let searchBar = self.searchController.searchBar
        
        collectionView.rx.contentOffset
            .asDriver()
            .drive(onNext: { _ in
                if searchBar.isFirstResponder {
                    _ = searchBar.resignFirstResponder()
                }
            }).disposed(by: disposeBag)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}




