//
//  PlayWithObservables.swift
//  RxSwiftDemo
//
//  Created by kaixin on 2021/10/2.
//

import Foundation
import RxSwift

// Really, "observalbe", "observable sequence" and "sequence" are all the same thing.
//    • An observable emits next events that contain elements.
//    • It can continue to do this until a terminating event is emitted, i.e., an error or completed event.
//    • Once an observable is terminated, it can no longer emit events.

public func example(of description: String, action: () -> Void)
{
    print("\n--- Example of:", description, "---")
    action()
}


// just : Create an observable sequence containing just a single element.
// It is a static method on Observable. However, in Rx, methods are referred to as “operators.”
func  operatorsUsage() -> Void {
    example(of: "just, of, from 操作符的使用") {
        let one = 1
        let two = 2
        let three = 3
        let ob = Observable<Int>.just(one)
        
        // 第一种方式
        ob.subscribe(onNext:{ element in
            print(element)
        })
        
        // 第二种方式
        // 如果含有多个闭包参数，那么第一个闭包参数中的参数就是 Int 类型。否则是 Event<Int>.
        ob.subscribe { e in
            
        } onError: { err in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }

        // 第三种方式
        ob.subscribe { event in
            print(event)
            if let element = event.element {
                print(element)
            }
        }
        
        
        let ob2 = Observable.of(one, two, three)
        ob2.subscribe { event in
            print(event)
        }
        let ob3 = Observable.of([one, two, three])
        ob3.subscribe { event in
            print(event)
        }
        let ob4 = Observable.from([one, two, three])
        ob4.subscribe { event in
            print(event)
        }
    }
    
    
    example(of: "empty 操作符的使用") {
        /*
            empty 操作符能且只能发出一个完成事件。
         */
        let ob = Observable<Void>.empty()
        ob.subscribe { () in
            
        } onError: { err in
            
        } onCompleted: {
            print("completed")
        }
        
        ob.subscribe(
            onNext: { element in // element 是 Void 类型，也就是空元组
                print(element)
            }, // 对比上面的那种写法，这么写得加逗号
            onCompleted: {
                print("completed")
            }
        )

    }
    
    
    example(of: "never 操作符的使用") {
        /*
            never 操作符不发出事件，也不停止事件
         */
        let ob = Observable<Void>.never()
        ob.subscribe { () in
            
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        }
    }
    
    example(of: "range 操作符的使用") {
        /*
            range 操作符，根据范围产生序列
         */
        
        let ob = Observable.range(start: 1, count: 10)
        ob.subscribe { element in
            print(element)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        }

    }
    
    
    example(of: "dispose 手动终止序列") {
        /*
            手动终止序列调用 .dispose() 。
            序列终止后，将不再发出事件。
         */
        let ob = Observable.of(1, 2, 3)
        // subscription(订阅) 保存订阅的返回值
        let subscription = ob.subscribe { element in
            print(element)
        }
        subscription.dispose() // 手动终止序列。
    }
    
    
    example(of: "dispose bag 的使用") {
        /*
            使用手动终止序列，比较麻烦，RxSwift 为我们提供了 dipose bag 。
            原理：
            将订阅的返回值，也就是 Disposable 的实例对象，添加到 disposebag 中。
            当 disposebag 销毁的时候，会清理其中的 diposable 对象。
            
            忘了写 .dispose(by:) ：
            如果忘记写导致内存泄露。但是，编译器会警告⚠️。
         */
        let disposebag = DisposeBag()
        Observable.of(1, 2, 3)
            .subscribe { element in // next 事件
                print(element)
            } onError: { error in  // error 事件
                print(error)
            } onCompleted: { // completed 事件
                print("completed")
            }
            .disposed(by: disposebag) // 将订阅的返回值 disposable 对象加入到 disposebag 中。
    }
    
    
    example(of: "使用 create 创建序列") {
        /*
            在使用 create 操作符时，我们可以定义所有的事件。
            其他的操作符对比：
            比如 just 操作符，内部默认包好了 发出完成事件，不需要我们自己定义。create 操作符则需要我们完全自己定义。
         */
        
        let disposebag = DisposeBag()
        Observable<Int>.create { observer in
            // 当序列被订阅后，发出 1， 2 ，然后发出完成事件。
            observer.onNext(1)
            observer.onNext(2)
            observer.onCompleted()
            observer.onNext(3) // completed 事件发出后，序列就被终止了，所以不会再发出元素 3 。
            return Disposables.create()
        }
        .subscribe { element in
            print(element)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        }
        .disposed(by: disposebag)

        
        /*
            发出 error 事件后，序列就被终止了。
         */
        enum MyError: Error {
            case anError
        }
        Observable<Int>.create { observer in
            // 当序列被订阅后，发出 1， 2 ，然后发出完成事件。
            observer.onNext(1)
            observer.onNext(2)
            observer.onError(MyError.anError)
            observer.onCompleted()
            observer.onNext(3) // completed 事件发出后，序列就被终止了，所以不会再发出元素 3 。
            return Disposables.create()
        }
        .subscribe { element in
            print(element)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        }
        .disposed(by: disposebag)
    }
    
    
    example(of: "deferred 操作符使用") {
        /*
            deferred 操作符用来创建并返回不同的 序列。所以可以说，它是创建不同序列的工厂。
            Observable.deferred(<#T##observableFactory: () throws -> Observable<_>##() throws -> Observable<_>#>)
         */
       
        let disposabebag = DisposeBag()
        let factory = Observable.deferred {
            // 在这里，我们可以添加逻辑返回不同的 序列。
            return Observable.of(1, 2, 3)
        }
        
        factory.subscribe { element in
            print(element)
        } onError: { error in
            print(error)
        } onCompleted: {
            print("completed")
        }
        .disposed(by: disposabebag)


    }
}


