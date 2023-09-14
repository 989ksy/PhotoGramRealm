//
//  ToDoTable.swift
//  PhotoGramRealm
//
//  Created by Seungyeon Kim on 2023/09/08.
//

import Foundation
import RealmSwift

class ToDoTable: Object {// 메인! 안에 작은 할일을 정리할 수 있었다.
    
    @Persisted(primaryKey: true) var _id: ObjectId //Primary Key
    @Persisted var title: String
    @Persisted var favorite: Bool
    
    //To Many Relationship, 외래키 연결해주기.
    //큰 일 안에 작은 일을 넣어서 데이터가 한방향으로 흘러 단방향 데이터가 될 수 있도록 세팅.
    //덕분에 투두 테이블에서 디테일을 세세히 알 수 있게 됨.
    @Persisted var detail: List<DetailTable> // 테이블이 또다른 테이블을 가지고 있어서, 여러 레코드를 가지고 올 수 있게 함./ 빈 배열
    
    //To One Relationship with EmbededObject(무조건 옵셔널 필수), 별도의 테이블이 생성되는 형태는 아님
    @Persisted var memo: Memo? //빈 배열 아니어서 옵셔널 필요.
    
    convenience init(title: String, favorite: Bool) {
        self.init()
        
        self.title = title
        self.favorite = favorite
    }
}

class DetailTable: Object { //작은 할일, 역관계를 생성해둠.
    
    @Persisted(primaryKey: true) var _id: ObjectId //Primary Key
    @Persisted var datail: String
    @Persisted var dealine: Date
    
    //Inverse Relationship Property (LinkingObjects)
    @Persisted(originProperty: "detail") var mainTodo: LinkingObjects<ToDoTable>
    // LinkingObjects = 자식이 속한 애가 어디에 속했는지 알아내는 부분. list 구조로 엮여있을 때에만 역관계 알 수 있음.
    // originalProperty의 detail은 todotable에 있는 detail : List<DetailTable>
    
    convenience init(datail: String, dealine: Date) {
        self.init()
        
        self.datail = datail
        self.dealine = dealine
    }
}

//투원 릴레이션십
class Memo: EmbeddedObject { // 특정컬럼에 들어갈 수 있는 형태 = embeddedObject
    @Persisted var content: String
    @Persisted var date: Date
}
