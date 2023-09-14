//
//  HomeViewController.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import SnapKit
import RealmSwift

class HomeViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.register(PhotoListTableViewCell.self, forCellReuseIdentifier: PhotoListTableViewCell.reuseIdentifier)
        return view
    }()
    
    var tasks: Results<DiaryTable>!
//    let realm = try! Realm() //realm에서 가져오는 게 아니면 파일경로 변경해주어야함. << DiaryTableRepository
    let repository = DiaryTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //realm read
        tasks = repository.fetch() //내용 추가, 내림차순
        //print(realm.configuration.fileURL)
        
        repository.checkSchemaVersion()
        
        print(tasks)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        //렘의 특성상 데이터가 어디에 오는지 연결만 해주면 그때부터 실시간으로 반영되는 지점이 존재, 데이터는 신경쓰지말고 데이터의 변경 지점만 신경 써주면 된다.
        
    }
    
    override func configure() {
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func plusButtonClicked() {
        navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
    @objc func backupButtonClicked() {
        navigationController?.pushViewController(BackupViewController(), animated: true)
    }
    
    
    @objc func sortButtonClicked() {
        
    }
    
    @objc func filterButtonClicked() {
        
//        let result = realm.objects(DiaryTable.self).where {
//            //1. 대소문자 구별 없음 = caseInsensitive
////            $0.dairyTitle.contains("제목", options: .caseInsensitive)
//
//            //2. Bool
////            $0.diaryLike == true
//
//            //3. 사진이 있는 데이터만 불러오기 (diaryPhoto의 nil 여부 판단)
//            $0.diaryPhoto != nil
//        }
        
        tasks = repository.fetchFilter()
        tableView.reloadData()
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.reuseIdentifier) as? PhotoListTableViewCell else { return UITableViewCell() }
        
        let data = tasks[indexPath.row]
        
        cell.titleLabel.text = data.dairyTitle
        cell.contentLabel.text = data.contents
        cell.dateLabel.text = "\(data.dairyDate)"
        cell.diaryImageView.image = loadImageFromDocument(fileName: "callie_\(data._id).jpg")
        
        
        //string -> URL -> Data -> UIImage
        //1. 셀 서버통신 (데이터가 작을 땐 cell에서 괜찮음, 하지만 크다면?)-> 뷰디드로드에서 데이터를 담고 난 후 이미지를 로드하는 과정을 구현. UIImage형식으로 바꿔서.
        // 셀 서버통신 용량이 크다면 로드가 오래 걸릴 수 있음.
        //2. 이미지를 미리 UIImage 형식으로 반환하고, 셀에서 UIImage를 바로 보여주자!
        // ==> 재사용 메커니즘을 효율적으로 사용하지 못할 수도 있고, UIImage 배열 구성자체가 오래 걸릴 수 있음
        
//        let value = URL(string: data.diaryPhoto ?? "")
//
//        DispatchQueue.global().async {
//            if let url = value, let data = try? Data(contentsOf: url) {
//
//                DispatchQueue.main.async {
//                    cell.diaryImageView.image = UIImage(data: data)
//                }
//            }
//        }
        
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        let vc = DetailViewController()
        vc.data = tasks[indexPath.row]

        navigationController?.pushViewController(vc, animated: true)
        
        
        
        //Realm Delete
//        let data = tasks[indexPath.row]
//
//        //파일이름에 맞춰서 도큐멘트에 있는 파일을 지워줘.
//        removeImageFromDocument(fileName: "callie_\(data._id).jpg")
//
//        try! realm.write {
//            realm.delete(data)
//        }
//
//        tableView.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let like = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("좋아요 선택됨")
        }
        
        like.backgroundColor = .orange
        like.image = tasks[indexPath.row].diaryLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        let sample = UIContextualAction(style: .normal, title: "테스트") { action, view, completionHandler in
            print("테스트 선택됨")
        }
        
        sample.backgroundColor = .brown
        sample.image = UIImage(systemName: "star.fill")

        
        return UISwipeActionsConfiguration(actions: [like, sample])
        
    }
    
    
}
