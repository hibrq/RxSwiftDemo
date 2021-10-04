//
//  PlayWithSubjects.swift
//  RxSwiftDemo
//
//  Created by kaixin on 2021/10/4.
//

import Foundation
import RxSwift
import RxRelay
enum MyError: Error {
    case anError
}
func playWithSubjects() {
    example(of: "PublishSubjects") {
        /*
            PublishSubjects is aptly named,because,like a publisher,it will receive information and then publish it to subscribers.
         */
        let publishSubject = PublishSubject<String>()
        publishSubject.on(.next("before subscribe subject"))
//        subject.subscribe { event in
//            print(event)
//        }
//        subject.subscribe(onNext:{ element in
//            print(element)
//        })
        
        _ = publishSubject.subscribe { str in
            print(str)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
        
        /*
            向 PushlishSubject 发送事件的两种不同的写法：
         */
        publishSubject.on(.next("hello 1")) // 普通写法
        publishSubject.onNext("hello 2") // 简便写法
        
        /*
            复习终止序列的三种方式：
            1. 发出 error、completed 事件
            2. 手动调用 dispose()
            3. 将订阅返回值 添加到 disposebag 中。
         */
//        subject.onError(MyError.anError)
        publishSubject.onCompleted()
    }
    
    example(of: "BehaviorSubjects") {
        /*
            BehaviorSubject 必须有初始值。
            订阅者可以订阅到最新的值，如果没有最新的值就会订阅到默认值。
         */
        let behaviorSubject = BehaviorSubject<String>(value: "default value")
        
        behaviorSubject.subscribe { element in
            print(element)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
        
        behaviorSubject.onNext("1")
//        behaviorSubject.onCompleted()
        behaviorSubject.onError(MyError.anError)
    }
    
    /*
        重放是指的在订阅之前添加到序列中的事件的重放。
        在订阅之后的事件，都可以正常订阅到。
     */
    example(of: "ReplaySubjects") {
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        replaySubject.onNext("0")
        replaySubject.onNext("1")
        replaySubject.onNext("2")
        replaySubject.subscribe { element in
            print(element)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }
        
        replaySubject.onNext("3")
        replaySubject.onCompleted()
        replaySubject.onError(MyError.anError)
        
    }
    
    example(of: "PublishRelay") {
        
        /*
            Relay(传递)：表示没有完成事件、错误事件，只有 next 事件。
            Relay 的作用：就是传递事件，不可以输入完成事件、错误事件。
            使用 accept 接收事件。
            
            PublishRelay：Publish 表示添加了 Publish 的特性（在订阅前接收的事件不会进行传递）
         */
        let publishRelay = PublishRelay<String>()
        let disposeBag = DisposeBag()
        publishRelay.accept("befor subscribe")
        
        publishRelay
            .subscribe { element in
                print(element)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposeBag)
        
        publishRelay.accept("2")
        
    }
    
    example(of: "BehaviorRelay") {
        let disposebag = DisposeBag()
        let behaviorRelay = BehaviorRelay<String>(value: "default value")
        
        behaviorRelay
            .subscribe { element in
                print(element)
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: disposebag)
        
        behaviorRelay.accept("1")
        behaviorRelay.accept("2")
    }
    
    example(of: "AsyncSubject") {
        /*
            AsyncSubject 这个主题表示，添加到序列中的最后一个元素才会被发出来。
         */
        let asyncSubject = AsyncSubject<String>()
        asyncSubject.onNext("before subscribe")
        asyncSubject
            .subscribe { element in
                print(element)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
        
        asyncSubject.onNext("1")
        asyncSubject.onNext("2")
//        asyncSubject.onCompleted()
        asyncSubject.onError(MyError.anError)
    }
}
