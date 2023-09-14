//
//  RealmCollectionViewController.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/14.
//

import UIKit
import SnapKit
import RealmSwift

class RealmCollectionViewController : BaseViewController {
    
    let realm = try! Realm()
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    //layout작성 후 괄호안에 frame 등 넣어주기.
    //UICollectionView() 비어있는 인스턴스를 불러도 문법적, 컴파일러에서도 오류는 나지 않지만, 실행을 하면 런타임 오류가 난다.
    //(Thread1: UICollectionView must be initialized with a non -nil layout parameter)
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, ToDoTable>!
    // xib연결 대신.
    // 두번째에 들어가는 제네릭은 let data = list[indexPath.item]의 data 타입이 들어간다고 생각하면 된다.
    
    var list: Results<ToDoTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list = realm.objects(ToDoTable.self)
        
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //itemidentifier = list[indexPath.row]
        cellRegistration = UICollectionView.CellRegistration(handler: { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.image = itemIdentifier.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            content.text = itemIdentifier.title
            content.secondaryText = "\(itemIdentifier.detail.count)개의 세부 할일"
            cell.contentConfiguration = content
        })
    
    }
    
    
    static func layout() -> UICollectionViewLayout {
        
        let configuration = UICollectionLayoutListConfiguration(appearance: .grouped) //어떤 구조의 컬렉션뷰?
        let layout = UICollectionViewCompositionalLayout.list(using: configuration) // 원하는 구조 레이아웃 연결해줌
        return layout

    }

    
    
}


extension RealmCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
        return cell
        
    }
    
}
