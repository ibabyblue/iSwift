//: [Previous](@previous)

import Foundation

var greeting = "Hello, subscript"

//MARK: Subscript
/*
 使用 subscript 可以给任意类型（枚举、结构体、类）增加下标功能，也称下标脚本。
 - subscript 类似于实例方法、计算属性，本质就是方法（函数）
 
 - subscript 中定义的返回值类型决定了，get方法返回类型，set方法中newValue的类型
 - subscript 可以接受多个参数，并且类型任意
 */

class Point {
    var x: Int = 0, y: Int = 0
    
    subscript(index: Int) -> Int {
        set {
            if 0 == index {
                x = newValue
            } else if 1 == index {
                y = newValue
            }
        }
        
        get {
            if 0 == index {
                return x
            } else if 1 == index {
                return y
            } else {
                return 0
            }
        }
    }
}

var p = Point();

p[0] = 1
p[1] = 2

print(p.x)
print(p.y)

//MARK: subscript 可以无 set 方法，但必须有 get 方法
/*
 如果只有get方法，get关键字可以省略
 */
class Size {
    var width: Float = 6, height: Float = 6
    
    subscript(index: Int) -> Float {
        get {
            if 0 == index {
                width
            } else if 1 == index {
                height
            } else {
                0
            }
        }
    }
    
//    //省略get
//    subscript(index: Int) -> Float {
//        if 0 == index {
//            width
//        } else if 1 == index {
//            height
//        } else {
//            0
//        }
//    }
}

var s = Size()
s[1]

//MARK: 参数标签
enum Season : Int {
    case spring = 1, summer, autumn, winter
    
    subscript(index i: Int) -> Int {
        get {
            switch i {
            case 1:
                return Season.spring.rawValue
            case 2:
                return Season.summer.rawValue
            case 3:
                return Season.autumn.rawValue
            case 4:
                return Season.winter.rawValue
            default:
                return -1
            }
        }
    }
}

var season = Season(rawValue: 2)
if let s = season {
    s[index: 3]
}

//MARK: 类型方法
class Sum {
    static subscript(v1: Int, v2: Int) -> Int {
        v1 + v2
    }
}

Sum[10, 20]

//MARK: 多参数下标
class Grid {
    var data = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8]
    ]
    subscript(row: Int, column: Int) -> Int {
        set {
            guard row >= 0 && row < 3 && column >= 0 && column < 3 else {
                return
            }
            data[row][column] = newValue
        }
        get {
            guard row >= 0 && row < 3 && column >= 0 && column < 3 else {
                return 0
            }
            return data[row][column]
        }
    }
}

var grid = Grid()
grid[0, 1] = 77
grid[1, 2] = 88
grid[2, 0] = 99
print(grid.data)

//MARK: 结构体、类作为返回值
////Dot为类
//class Dot {
//    var x: Int = 0, y: Int = 0
//}
//
//class PointManager {
//    var point: Dot = Dot()
//    
//    subscript(index: Int) -> Dot {
//        get { point }
//    }
//}

//Dot为结构体
struct Dot {
    var x: Int = 0, y: Int = 0
}

class PointManager {
    var point: Dot = Dot()
    
    subscript(index: Int) -> Dot {
        set {
            point = newValue
        }
        get { point }
    }
}

var pm = PointManager()

pm[0].x = 1
pm[0].y = 2
print(pm[0].x)
print(pm[0].y)

/*
 结论：
 - 结构体作为下标返回值时，修改属性值时，必须设置下标的 set 方法 （值传递）
 - 类作为下标返回值时，修改属性值时，则下标的 set 方法省略（引用传递）
 */


//: [Next](@next)
