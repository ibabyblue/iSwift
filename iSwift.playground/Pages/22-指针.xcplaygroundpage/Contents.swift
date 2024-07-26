//: [Previous](@previous)

import Foundation
import UIKit

var greeting = "Hello, Pointer"

//MARK: - 指针
/*
 • Swift中的指针类型：
 - UnsafePointer<Pointee> 类似于 const Pointee * (只读的泛型指针)
 - UnsafeMutablePointer<Pointee> 类似于 Pointee * (可读可写的泛型指针)
 - UnsafeBufferPointer<Pointee> 类似于 const Pointee *（只读的内存缓冲区指针）集合指针类型
 - UnsafeMutableBufferPointer 类似于 Pointee * (可读可写的内存缓冲区指针) 集合指针类型
 - UnsafeRawPointer 类似于 const void * (只读的原始类型指针)
 - UnsafeMutableRawPointer 类似于 void * (可读可写的原始类型指针)
 */

var age = 10

func test1(_ ptr: UnsafeMutablePointer<Int>) {
    ptr.pointee += 10
}

func test2(_ ptr: UnsafePointer<Int>) {
    print(ptr.pointee)
}

func test3(_ ptr: UnsafeMutableRawPointer) {
    ptr.storeBytes(of: 40, as: Int.self)
}

func test4(_ ptr: UnsafeRawPointer) {
    print(ptr.load(as: Int.self))
}

test1(&age)
test2(&age)
print(age)

test3(&age)
test4(&age)
print(age)

/*
 - 泛型指针可以通过指针变量属性 pointee 读写内存
 - 原始指针通过 load 实例方法读取内存数据，参数 as 传入创建的实例类型
 - 原始指针通过 storeBytes 实例方法写入数据，参数 as 传入存储数据的类型，参数 of 传入数据
 */

//MARK: - 指针应用示例
var arr = NSArray(objects: 11, 22, 33, 44)
arr.enumerateObjects { (obj, idx, stop) in
    print(idx, obj)
    if idx == 2 { // 下标为2就停止遍历
        stop.pointee = true
    }
}

//MARK: - 获取指针
//MARK: 获取指向某个变量的指针
//withUnsafePointer函数的第一个参数是传入变量的地址，第二个参数是闭包，闭包的参数其实是函数的第一个参数，返回值是一个泛型（传参是什么类型，返回值就是什么类型）
var ptr = withUnsafePointer(to: &age) { $0 }
print(ptr.pointee)

//MARK: 获得指向堆空间实例的指针
class Person {
    var age: Int = 0
    init(age: Int) {
        self.age = age
    }
}

var person = Person(age: 10)

var personPtr = withUnsafePointer(to: &person) { $0 }
print(personPtr.pointee.age) // 输出：10

/*
 思考：ptr存储的是什么？存储的是变量person的地址值还是堆空间Person对象的地址值？
 - person变量的地址值，其实从withUnsafePointer的入参和返回值也能反映出ptr存储的是person变量的地址值，
 因为传入什么，返回值就是什么。ptr本质就是person
 */

var ptr1 = withUnsafePointer(to: &person) { UnsafeRawPointer($0) }
var personObjAddress = ptr1.load(as: UInt.self)
var ptr2 = UnsafeMutableRawPointer(bitPattern: personObjAddress)
print(ptr2 as Any)
/*
 ptr1保存的是person地址值，所以ptr1.load取的是person保存的地址personObjAddress（对象堆空间地址）
 ptr2指针指向了对象堆空间地址
 */

//MARK: - 创建指针
//1.malloc创建
// 堆空间创建指针（16代表申请16个字节的内存，返回值类型是UnsafeMutableRawPointer可选类型）
var mPtr = malloc(16)

// 存数据
// 指针前8个字节填充数据（Int类型数字10）
// of: 存放的数据
// as: 存放的数据类型
mPtr?.storeBytes(of: 10, as: Int.self)
// 指针后8个字节填充数据（Int类型数字20）
// toByteOffset: 字节偏移量（偏移8代表是因为Int占用8个字节）
mPtr?.storeBytes(of: 10, toByteOffset: 8, as: Int.self)

// 取数据
// 取出指针指向的内存前8个字节的数据
print((mPtr?.load(as: Int.self))!) // 输出：10
// 取出指针指向的内存后8个字节的数据（参数同存数据）
print((mPtr?.load(fromByteOffset: 8, as: Int.self))!) // 输出：20

// 销毁
free(mPtr)

//注意:通过 malloc 创建的指针一定要在结束后销毁

//2.UnsafeMutableRawPointer.allocate 创建
// 创建指针（返回值是UnsafeMutableRawPointer类型）
// byteCount: 申请的字节大小
// alignment: 对齐数（一般写1就好）
var urPtr = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)

// 存数据
// 存储前8个字节数据
urPtr.storeBytes(of: 11, as: Int.self)
// advanced返回的是uPtr偏移by字节的UnsafeMutableRawPointer类型的指针
// 意思是：uPtr后8个字节存储Int类型22
urPtr.advanced(by: 8).storeBytes(of: 22, as: Int.self)

// 取数据
print(urPtr.load(as: Int.self)) // 输出：11
print(urPtr.advanced(by: 8).load(as: Int.self)) // 输出：22

// 销毁
urPtr.deallocate()

//注意:advanced返回的是偏移指定字节后的指针

//3.UnsafeMutablePointer.allocate 创建
// 创建指针
// capacity: 容量（3就是申请24字节的内存--因为Int占用8个字节，所以一共是24字节）
var upPtr = UnsafeMutablePointer<Int>.allocate(capacity: 3)

// 存数据
// 第一种初始化方式：pointee: 操作的是前8个字节
//upPtr.pointee = 10

// 第二种初始化方式：initialize: 用10去初始化内存空间（前8个字节）
upPtr.initialize(to: 10)

// 第三种初始化方式：连续存储：连续count*Int个字节重复存储repeating（连续2块内存都存储数字10）
// count: 重复次数
// repeating: 重复数据
//upPtr.initialize(repeating: 10, count: 2)

// 后继: 跳过8个字节，返回指针（跳过前8个字节的指针存储20）
upPtr.successor().initialize(to: 20)
// 可以连续跳（连续跳过前面16个字节）
upPtr.successor().successor().initialize(to: 30)

// 取数据
// 取数据方式一
// 前8个字节
print(upPtr.pointee) // 输出：10
// 往下移动n*8个字节
print((upPtr + 1).pointee) // 输出：20
print((upPtr + 2).pointee) // 输出：30
// 取数据方式二
// 取出第n段（每段8个字节）的字节
print(upPtr[0]) // 输出：10
print(upPtr[1]) // 输出：20
print(upPtr[2]) // 输出：30

// 反初始化
upPtr.deinitialize(count: 3)
// 销毁
upPtr.deallocate()

/*
 注意：
 - 使用泛型指针initialize初始化数据时，一定要使用deinitialize反初始化（count和initialize次数要一致）
 - UnsafeMutableRawPointer.allocate因为没有指定类型，所以需要传入指定类型和字节
 - UnsafeMutablePointer.allocate是泛型指针，所以只需要告诉系统创建多大容量的内存
*/

//示例代码 - 对象
//class Person {
//    var age: Int
//    var name: String
//    init(age: Int, name: String) {
//        self.age = age
//        self.name = name
//    }
//    deinit {
//        print(name, "deinit")
//    }
//}
//
//var ptr = UnsafeMutablePointer<Person>.allocate(capacity: 3)
//ptr.initialize(to: Person(age: 10, name: "Jack"))
//(ptr + 1).initialize(to: Person(age: 11, name: "Rose"))
//(ptr + 2).initialize(to: Person(age: 12, name: "Kate"))
//print("1")
//ptr.deinitialize(count: 3)
//print("2")
//ptr.deallocate()
//print("3")
/*
 输出：
 1
 Jack deinit
 Rose deinit
 Kate deinit
 2
 3
 */
/*
 如果上面的代码不写deinitialize，就不会有deinit输出；
 如果deinitialize(count: 2)，第三个initialize就不会释放；
 所以一定要及时正确的使用deinitialize，否则会有内存泄漏
 建议：在函数内部创建指针时，把指针释放的代码放到defer函数体内
 */

//MARK: UnsafeBufferPointer和UnsafeMutableBufferPointer
/*
 - UnsafeBufferPointer 只读
 - UnsafeMutableBufferPointer 可读可写
 */
//示例代码：
var nArr = [1, 2, 3, 4, 5]
nArr.withUnsafeBufferPointer { bufferPointer in
    for (index, value) in bufferPointer.enumerated() {
        print("Index:\(index) Value:\(value)")
    }
}

nArr.withUnsafeMutableBufferPointer { bufferPointer in
    for index in bufferPointer.indices {
        bufferPointer[index] *= 2
    }
}
print(nArr) // 2 4 6 8 10

let count = 5
let bufferPointer = UnsafeMutableBufferPointer<Int>.allocate(capacity: count)

for i in 0..<count {
    bufferPointer[i] = i * 2
}

for (index, value) in bufferPointer.enumerated() {
    print("Index \(index): \(value)")
}

bufferPointer.deallocate()


//MARK: - 指针之间的转换
//示例代码
// 创建指针
var cPtr = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 1)

// 把原始指针转换为泛型指针
// to: 转换目标类型
cPtr.assumingMemoryBound(to: Int.self).pointee = 11
(cPtr + 8).assumingMemoryBound(to: Double.self).pointee = 22.0

// unsafeBitCast强制转换
// 第一个参数：待转换的指针
// 第二个参数：转换目标指针类型
print(unsafeBitCast(cPtr, to: UnsafePointer<Int>.self).pointee) // 输出：11
print(unsafeBitCast(cPtr + 8, to: UnsafePointer<Double>.self).pointee) // 输出：22.0

cPtr.deallocate()

/*
 unsafeBitCast是忽略数据类型的强制转换，不会因为数据类型的变化而改变原来的内存数据
 （可以认为是内存数据直接搬过去的，一般情况下的强制转换都会改变原来的内存数据形成新的内存数据存储）
 */

var p = Person(age: 10)
var pPtr = unsafeBitCast(p, to: UnsafeRawPointer.self)
print(pPtr) // 输出：0x0000000100556d10

//p保存的是Person对象的堆空间地址，unsafeBitCast就是把p保存的内存地址拿出来原封不动转换为UnsafeRawPointer类型的指针给pPtr，所以pPtr保存的地址和p保存的地址是一样的

//另一种方式是把p地址取出来，利用地址创建一个指针指向堆空间：
var address = unsafeBitCast(p, to: Int.self)
var aPtr = UnsafeRawPointer(bitPattern: address)

/*
 注意：原始指针和泛型指针 ptr + 8 是有区别的
 原始指针 ptr + 8 指的是跳过 8 个字节，泛型指针指的是跳过 8*类型占用字节 个字节
 */

//: [Next](@next)
