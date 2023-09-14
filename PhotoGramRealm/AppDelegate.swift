//
//  AppDelegate.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //컬럼과 테이블 단순 추가 삭제의 경우엔 별도 코드가 필요없음
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            
            //출시 순간부터 영구적으로 가져가야하는 코드임. 그러므로, 출시 전까진 migration 하지 않기. 영영..지울수..없으..니까...
            if oldSchemaVersion < 1 { } // diaryPin Column 추가
            
            if oldSchemaVersion < 2 { } // diaryPin Column 삭제
            
            if oldSchemaVersion < 3 {
                migration.renameProperty(onType: DiaryTable.className(), from: "diaryPhoto", to: "photo")
            } //diaryPhto -> photo Column 이름 변경 //내가 실수해서 여긴 null값 나옴..ㅋㅋ...
            
            if oldSchemaVersion < 4 { } // diaryContents -> contest 이름 변경
            
            if oldSchemaVersion < 5 { // diarySummary 컬럼 추가, title + contents 합쳐서 넣기
                migration.enumerateObjects(ofType: DiaryTable.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["dairySummary"] = "제목은 '\(old["dairyTitle"])'이고, 내용은 '\(old["contents"])'입니다."
                }
                
            } //DairySummary 컬럼 추가, title + contents 합쳐서 넣기
            
            if oldSchemaVersion < 6 {
                migration.renameProperty(onType: DiaryTable.className(), from: "photo", to: "image")
            } //photo -> photo Column
            
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

