//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Share、Multicast"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - Share
testSample(label: "01_Share", action: false) {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .sink { completion in
            print("01_share_v1_completion:\(completion)");
        } receiveValue: { val in
            print("01_share_v1_receiveValue:\(val)");
        }.store(in: &cancell)
    srcPublisher
        .sink { completion in
            print("01_share_v2_completion:\(completion)");
        } receiveValue: { val in
            print("01_share_v2_receiveValue:\(val)");
        }.store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .finished)
}
/*
 结果:订阅几次，数据发送几次
 01_share_v1_receiveValue:1
 01_share_v2_receiveValue:1
 01_share_v1_receiveValue:2
 01_share_v2_receiveValue:2
 01_share_v1_completion:finished
 01_share_v2_completion:finished
 */

testSample(label: "02_Share", action: false) {
    let arrPublisher = [1,2,3,4,5]
                        .publisher
                        .share() //加上share()则共享数据只发送一套数据(publisher变成Multicast类型)
                        .print()
    arrPublisher
        .sink(receiveValue: {_ in })
    arrPublisher
        .sink(receiveValue: {_ in })
}
/*
 结果:不调用share()，有几次订阅，就发送几次数据
 receive subscription: ([1, 2, 3, 4, 5])
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive value: (4)
 receive value: (5)
 receive finished
 receive subscription: ([1, 2, 3, 4, 5])
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive value: (4)
 receive value: (5)
 receive finished
 
 结果:加了share()，则共享数据，只发送一套数据
 receive subscription: (Multicast)
 request unlimited
 receive value: (1)
 receive value: (2)
 receive value: (3)
 receive value: (4)
 receive value: (5)
 receive finished
 receive subscription: (Multicast)
 request unlimited
 receive finished
 */

testSample(label: "03_Share", action: false) {
    struct ProductInfoRes : Codable {
        var productInfo : [ProductInfo]
    }
    
    struct ProductInfo : Codable {
        var productId : String
        var price : Int
    }
    
    let defaultProductInfo = ProductInfoRes(productInfo: [])
    let url = URL(string: "https://www.baidu.com")
    let posts = URLSession.shared.dataTaskPublisher(for: url!)
        .print()
        .map{$0.data}
        .decode(type: ProductInfoRes.self, decoder: JSONDecoder())
        .replaceError(with: defaultProductInfo)
        .share() //添加share()，网络请求只会执行一次，如果不添加，则有几次订阅，就请求几次
    
    posts.sink { receiveValue in
        print("03_share_v1_receiveValue:\(receiveValue)");
    }
    .store(in: &cancell)
    
    posts.sink { receiveValue in
        print("03_share_v2_receiveValue:\(receiveValue)");
    }
    .store(in: &cancell)
}

//MARK: - Connect
testSample(label: "01_Connect", action: false) {
    struct ProductInfoRes : Codable {
        var productInfo : [ProductInfo]
    }
    
    struct ProductInfo : Codable {
        var productId : String
        var price : Int
    }
    
    let defaultProductInfo = ProductInfoRes(productInfo: [])
    let url = URL(string: "https://www.baidu.com")
    let posts = URLSession.shared.dataTaskPublisher(for: url!)
        .print()
        .map{$0.data}
        .decode(type: ProductInfoRes.self, decoder: JSONDecoder())
        .replaceError(with: defaultProductInfo)
        .makeConnectable() //使发布者Publisher可以使用connect方法，一起让订阅生效
    
    //订阅一
    posts.sink { receiveValue in
        print("01_connect_v1_receiveValue:\(receiveValue)");
    }
    .store(in: &cancell)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: DispatchWorkItem(block: {
        //订阅二
        posts.sink { receiveValue in
            print("01_connect_v2_receiveValue:\(receiveValue)");
        }
        .store(in: &cancell)
        
        posts
            .connect() //这里使用了connect()之后，订阅一和订阅二才一起生效
            .store(in: &cancell)
    }))
}

//MARK: - Multicast
//同时拥有share()、makeConnectable()的特性
testSample(label: "01_Multicast", action: false) {
    
    let url = URL(string: "https://www.baidu.com")
    let multicasted = URLSession.shared.dataTaskPublisher(for: url!)
        .print()
        .map{$0.data}
        .multicast{PassthroughSubject<Data, URLError>()}
    
    //订阅一
    print("---订阅一:start---")
    multicasted
        .sink { completion in
            print("01_multicast_v1_completion:\(completion)");
        } receiveValue: { val in
            print("01_multicast_v1_receiveValue:\(val)");
        }.store(in: &cancell)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: {
        //订阅二
        print("---订阅二:start---")
        multicasted
            .sink { completion in
                print("01_multicast_v2_completion:\(completion)");
            } receiveValue: { val in
                print("01_multicast_v2_receiveValue:\(val)");
            }.store(in: &cancell)
    }))
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: DispatchWorkItem(block: {
        print("---connect:start---")
        multicasted
            .connect() //这里使用了connect()之后，订阅一和订阅二才一起生效
            .store(in: &cancell)
    }))
}

//MARK: - Future
//Future 使用share() 只有第一个订阅者可以收到数据
testSample(label: "01_Future", action: true) {
    var cnt = 1
    let future = Future<Int, Never>{ fullfil in
            cnt += 1
            print("hello")
            fullfil(.success(cnt))
        }
        .share()
        .print()
        
    
    future
        .sink { print("01_future_v1_receive:\($0)") }
        .store(in: &cancell)
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: DispatchWorkItem(block: {
        future
            .sink { print("01_future_v2_receive:\($0)") }
            .store(in: &cancell)
//    }))
}
/*
 结果: 加share()，只有第一个订阅者收到数据，不加share()，两个订阅者都收到数据
 hello
 01_future_v1_receive:2
 */
//: [Next](@next)
