//
//  ToDoViewController.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/08.
//
//외래키 사용해서 테이블 안에 테이블 넣는 방법.
//복합적인 테이블

import UIKit
import RealmSwift
import SnapKit

class ToDoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    let tableView = UITableView()
    
    var list: Results<DetailTable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let data = ToDoTable(title: "영화보기", favorite: false)
//
//        let memo = Memo()
//        memo.content = "주말에 팝콘 먹으면서 영화 보기"
//        memo.date = Date()
//
//        data.memo = memo
//
//        try! realm.write {
//            realm.add(data)
//        }
////
//
//        //todotable의 장보기에 detail 수가 채워져서 나오고 있음.
//
//        let data = ToDoTable(title: "장보기", favorite: true)
//        let detail1 = DetailTable(datail: "양파", dealine: Date())
//        let detail2 = DetailTable(datail: "당근", dealine: Date())
//        let detail3 = DetailTable(datail: "사과", dealine: Date())
//
//        data.detail.append(detail1)
//        data.detail.append(detail2)
//        data.detail.append(detail3)
//
//        try! realm.write {
//            realm.add(data)
//        }
                
        print(realm.configuration.fileURL)
        print(realm.objects(ToDoTable.self))
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "todoCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)

        }
        
        list = realm.objects(DetailTable.self)
                
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell")!
//        cell.textLabel?.text = "\(list[indexPath.row].title): \(list[indexPath.row].detail.count)개 \(list[indexPath.row].memo?.content ?? "")"
        
        let data = list[indexPath.row]
        cell.textLabel?.text = "\(data.datail) in \(data.mainTodo.first?.title ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //셀 선택 시 특정 인덱스 확인 -> 데이터 삭제 -> 갱신코드
        
//        //리스트에 해당하는 값을 데이터에 담았다.
//        let data = list[indexPath.row]
//
//        try! realm.write {
//            realm.delete(data.detail) //렘에 디테일이 잇는데 디테일 먼저 지워줘.
//            realm.delete(data)
//        }
//
//        tableView.reloadData()
        
    }
    
    func createDetail() {
        print(realm.objects(ToDoTable.self))
//        createToDo()
        
        let main = realm.objects(ToDoTable.self).where { //여러 렘파일에서 todo테이블을 찾는다 / todo테이블에 접근이 되어있는 상태.
            $0.title == "장보기" // 타이틀이 장보기인 애를 필터링 해라.
        }.first!
        
        for i in 1...10 {
            
            let detailToDo = DetailTable(datail: "장보기 세부 할일 \(i)", dealine: Date())
            
            try! realm.write {
//                realm.add(detailToDo)
                main.detail.append(detailToDo)
            }
        }
        
    }
    
    
    func createToDo() {
        for i in ["장보기", "영화보기", "리캡하기", "좋아요 구현하기", "잠자기"]{
            
            let data = ToDoTable(title: i, favorite: false)
            try! realm.write{
                realm.add(data)
            }
        }
        
    }
    
    
}
