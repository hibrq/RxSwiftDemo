//
//  FilterOperators.swift
//  RxSwiftDemo
//
//  Created by kaixin on 2021/10/6.
//

import Foundation
import RxSwift

func filterOperators() {
    example(of: "ignoreElements") {
        let bag = DisposeBag()
        let sub = PublishSubject<Int>()
        sub
            .ignoreElements()
            .subscribe(onError: { error in
                print(error)
            }, onCompleted: {
                print("completed")
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: bag)
        sub.onNext(1)
//        sub.onCompleted()
        sub.onError(MyError.anError)

    }
    
    example(of: "elementAt") {
        let bag = DisposeBag()
        let sub = PublishSubject<Int>()
        sub
            .element(at: 2)
            .subscribe { element in
                print(element)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: bag)
        sub.onNext(1)
        sub.onNext(2)
        sub.onNext(3)
        sub.onNext(4)
        sub.onCompleted()
        sub.onError(MyError.anError)

    }
    
    example(of: "filter") {
        let bag = DisposeBag()
        Observable.of(0, 1, 2, 3, 4, 5, 6)
            .filter {
                $0.isMultiple(of: 2)
            }
            .subscribe { element in
                print(element)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: bag)
        print("---")

        
    }
    
    
    example(of: "skip") {
        let bag = DisposeBag()
        Observable.of(1, 2, 3, 4)
            .skip(1)
            .subscribe { element in
                print(element)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: bag)

    }
    
    
    example(of: "skipWhile") {
        /*
            skip(while:) 只是过滤掉第一满足条件的元素。其他元素不受影响。
         */
        let bag = DisposeBag()
        Observable.of(2, 2, 3, 4, 4)
            .skip(while: { element in
                return element.isMultiple(of: 2)
            })
            .subscribe { element in
                print(element)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: bag)
    }
    

    example(of: "skipuntil") {
        let bag = DisposeBag()
        let sub1 = PublishSubject<Int>()
        let sub2 = PublishSubject<Int>()
        sub1
            .skip(until: sub2)
            .subscribe { element in
                print(element)
            } onError: { error in
                print(error)
            } onCompleted: {
                print("complted")
            } onDisposed: {
                print("disposed")
            }
            .disposed(by: bag)
        
        sub2
            .subscribe { element in
                print(element)
            }
            .disposed(by: bag)

        sub1.onNext(1)
        sub1.onNext(2)
        sub2.onNext(11)
        sub1.onNext(3)

    }
}
