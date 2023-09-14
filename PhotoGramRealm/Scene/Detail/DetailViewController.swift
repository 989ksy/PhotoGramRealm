//
//  DetailViewController.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/05.
//

import UIKit
import SnapKit
import RealmSwift

class DetailViewController: BaseViewController {
    
    //값전달
    
    var data: DiaryTable?
    
    let realm = try! Realm()
    
    let repository = DiaryTableRepository()
    
    
    let titleTextField: WriteTextField = {
        let view = WriteTextField()
        view.placeholder = "제목을 입력해주세요"
        view.textColor = .white
        view.attributedPlaceholder = NSAttributedString(string:"제목을 입력해주세요", attributes: [.foregroundColor: UIColor.systemGray])
        return view
    }()
    
    let contenteTextField: WriteTextField = {
        let view = WriteTextField()
        view.textColor = .white
        view.attributedPlaceholder = NSAttributedString(string:"내용을 입력해주세요", attributes: [.foregroundColor: UIColor.systemGray])
        return view
    }()
    
    
    override func configure() {
        view.addSubview(titleTextField)
        view.addSubview(contenteTextField)
        
        guard let data = data else { return }
        
        titleTextField.text = data.dairyTitle
        contenteTextField.text = data.contents
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editButtonClicked))
        
//        print(data?.dairyTitle) //값전달 확인
    }
    
    @objc func editButtonClicked() {
        
        //Realm Upate3]
        guard let data = data else { return }
        
        repository.updateItem(id: data._id, title: titleTextField.text!, contents: contenteTextField.text!)

        
        //Realm Update2 << DiaryTableRepository 이후
//        guard let data = data else { return }
        
//        let item = DiaryTable(value: ["_id": data._id, "dairyTitle": titleTextField.text!, "diaryContents": contenteTextField.text!])
//
//        do {
//            try realm.write {
//                realm.create(DiaryTable.self, value: ["_id": data._id, "dairyTitle": titleTextField.text!, "diaryContents": contenteTextField.text!], update: .modified)
//            }
//        } catch {
//            print("") //
//        }
        
        
        //Realm Update1
//        guard let data = data else { return }
//        let item = DiaryTable(value: ["_id": data._id, "dairyTitle": titleTextField.text!, "diaryContents": contenteTextField.text!])
//
//        do {
//            try realm.write {
//            realm.add(item, update: .modified)
//            }
//        } catch {
//            print("") //
//        }
        
//        try! realm.write {
//            realm.add(item, update: .modified) //modified로 수정을 하려고 add 하는 거야. update 매개변수 살려서 호출해서 써야함.
//
//        } -> 강제해제 하지 않기 위해 do-try-catch 로 변경
        
        navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.center.equalTo(view)
        }
        
        contenteTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view).offset(60)
        }
        
    }
    
}
