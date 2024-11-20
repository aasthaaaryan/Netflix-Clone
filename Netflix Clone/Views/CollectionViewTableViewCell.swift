//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Aastha Aaryan on 04/11/24.
//

import UIKit
import SwiftUI

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell : CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate : CollectionViewTableViewCellDelegate?
    
    private var titles : [Title] = [Title]()
    
    
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero , collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
       super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with titles: [Title]){
        self.titles = titles
        DispatchQueue.main.async {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    private func downloadTitleAt(indexPath: IndexPath){
        
        DataPersistanceManager.shared.downloadTitleWith(model: titles[indexPath.row]){ result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        print("Downloading \(String(describing: titles[indexPath.row].original_title))")
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell()}
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titlename = title.original_title ?? title.original_name else { return}
        
        APICaller.shared.getMovie(with: titlename + " trailer") { [weak self] result in
            switch result {
            case.success(let VideoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let strongSelf = self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titlename, youtubeView: VideoElement, titleOverview: titleOverview)
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            
            case.failure(let error):
                print(error.localizedDescription + "not")
                
            }}
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                contextMenuConfigurationForItemAt indexPath: IndexPath,
                                point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download",
                                          subtitle: nil,
                                          image: UIImage(systemName: "arrow.down.circle"),
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", children: [downloadAction])
        }
    }

    
//    private func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        
//        let config = UIContextMenuConfiguration(
//        identifier: nil,
//        previewProvider: nil) { [weak self] _ in
//            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil,discoverabilityTitle: nil, state: .off) { _ in
//                self?.downloadTitleAt(indexPath: indexPath)
//            }
//            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
//        }
//                          return config
//    }
}
