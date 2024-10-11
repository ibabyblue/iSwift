//: [Previous](@previous)

import Foundation

var greeting = "Hello, string"

//MARK: - 字符串操作
//MARK: 字符串拼接
//空字符串
var emptyStr1 = ""
var emptyStr2 = String()

var aStr = "1"
//拼接
aStr.append("_2")
//重载运算符+
aStr = aStr + "_3"
//重载运算符+
aStr += "_4"
// \()插值
aStr = "\(aStr)_5"
// 长度
print(aStr,aStr.count) // 输出：1_2_3_4_5 9
print(aStr.hasPrefix("1")) // 输出：true
print(aStr.hasSuffix("5")) // 输出：true

//MARK: 字符串插入和删除
/*
 Swift字符串属性：
 - startIndex：String.Index类型，字符串的第一个位置
 - endIndex：String.Index类型，比字符串最后一个位置大（注意不是最后一个位置）,比如 string 的endIndex是g的索引+1
 */
var mStr = "1_2"
//拼接字符
mStr.insert("_", at: mStr.endIndex) // 1_2_
//拼接字符串
mStr.insert(contentsOf: "3_4", at: mStr.endIndex) //1_2_3_4
//开始索引之后的位置插入
mStr.insert(contentsOf: "666", at: mStr.index(after: mStr.startIndex)) //1666_2_3_4
//在字符串的 startIndex 之前插入内容，这是不合法的，下面这行代码是错误示例
//mStr.insert(contentsOf: "pre", at: mStr.index(before: mStr.startIndex))
//结束索引之前的位置插入
mStr.insert(contentsOf: "888", at: mStr.index(before: mStr.endIndex)) //1666_2_3_8884
//按照索引位置偏移量插入
mStr.insert(contentsOf: "hi", at: mStr.index(mStr.startIndex, offsetBy: 4)) //1666hi_2_3_8884

//按照索引位置删除
mStr.remove(at: mStr.firstIndex(of: "1")!) //666hi_2_3_8884
//遍历每个字符，返回true删除，否则不删
mStr.removeAll() { $0 == "6" } //hi_2_3_8884
//按照字符串范围删除
let range = mStr.index(mStr.endIndex, offsetBy: -4)..<mStr.index(before: mStr.endIndex)
mStr.removeSubrange(range) //hi_2_3_4

//打印第一个字符与第二个字符的间距数值
print(mStr.distance(from: mStr.startIndex, to: mStr.index(after: mStr.startIndex)))

//MARK: - Substring
/*
 - Substring和它的base，共享字符串数据
 - Substring发生修改或者转为String时，会重新分配新的内存存储字符串数据
 */
//String可以通过下标、prefix、suffix等截取子串，子串类型不是String，而是Substring（如果要使用String的所有函数和属性，可以把Substring转换为String）
var sStr = "1_2_3_4_5"
var preStr = sStr.prefix(3) //1_2
var sufStr = sStr.suffix(3) //4_5

let sRange = sStr.startIndex..<sStr.index(sStr.startIndex, offsetBy: 3)
var rStr = sStr[sRange] //1_2
rStr.base //1_2_3_4_5

String(rStr) // Substring -> String

//MARK: - String和Character
for c in "idbeny" {
    print(c)
}
/*
 输出：
 i
 d
 b
 e
 n
 y
 */

var str = "idbeny"
var c = str[str.startIndex]
print(c) // 输出：i
//示例中c是Character类型，因为传入的是单个位置。如果下标传入的是一个范围，就是Substring类型

//MARK: - String相关协议
/*
 - BidirectionalCollection协议
    - String扩展遵守StringProtocol协议，而StringProtocol协议遵守BidirectionalCollection协议，
      BidirectionalCollection协议有startIndex、endIndex属性，index方法
    - String和Array都遵守了这个协议。只不过Array指定了startIndex、endIndex等属性是Int类型，
      String相关属性是String.Index类型（内部实现原理是BidirectionalCollection协议的关联类型）
 - RangeReplaceableCollection协议
    - RangeReplaceableCollection协议中有append、insert、remove方法，String、Array都遵守了这个协议
    - Dictionary、Set也有实现上述协议中声明的一些方法，只是并没有遵守上述协议
 */

//MARK: - 多行String
//代码示例一：使用三个双引号"""内容"""把内容括起来就可以实现多行String，多行内容必须在"""后面新起一行
let multiStr = """
第一行
    第二行
        第三行
    第四行
第五行
"""
print(multiStr)
/*
 输出：
 第一行
     第二行
         第三行
     第四行
 第五行
 */

//代码示例二：如果要显示3引号，至少转义1个引号
let tStr = """
Escaping the first quotation mark \"""
Escaping all three quotation marks \"\"\"
"""
print(tStr)
/*
 输出：
 Escaping the first quotation mark """
 Escaping all three quotation marks """
 */

//代码示例三：缩进以最后一个结尾引号为对齐线
let reStr = """
This string starts with a line break.
It also ends with a line break.
"""

//let reStr = """
//    This string starts with a line break.
//    It also ends with a line break.
//    """

print(reStr)
/*
 输出：
 This string starts with a line break.
 It also ends with a line break.
 */

//MARK: - String和NSString
//1.转换
/*
 注意：String与NSString之间相互转换是有转换代价的（调用函数），但是可以忽略不计。String不能桥接转换成NSMutableString
 */
var str1: String = "jack"
var str2: NSString = "rose"

var str3 = str1 as NSString //转为 NSString
var str4 = str2 as String //转为 String

var str5 = str3.substring(with: NSRange(location: 0, length: 2))
print(str5) // 输出：ja

var s1 = str1 as NSString
var s2 = str1 as NSString
//在Swift中判断NSString是否相等使用isEqual，本质上会调用isEqualToString:判断是否相等
s1.isEqual(s2)

//2.比较字符串内容是否等价
/*
 - String使用 == 运算符
 - NSString使用isEqual()方法，也可以使用 == 运算符（本质还是调用了isEqual方法）
 - 在OC中使用==来判断是否相等
    - 如果两个变量是基本类型的变量,而且都是数值型(不一定要求数据类型严格相同),则只要两个变量相等,使用==判断就将返回真
    - 对于两个指针类型的变量,它们必须指向同一个对象(也就是两个指针变量保存的内存地址相同)时，使用==判断才会返回真
 */

//Swift和OC桥接转换表：
/*
 • String
    - String <-> NSString  双向 as
    - String <- NSMutableString 单向 as
 • Array
    - Array <-> NSArray 双向 as
    - Array <- NSMutableArray 单向 as
 • Dictionay
    - Dictionay <-> NSDictionay 双向 as
    - Dictionay <- NSMutableDictionay 单向 as
 • Set
    - Set <-> NSSet 双向 as
    - Set <- NSMutableSet 单向 as
 */

//String 转换为 NSMutableString 注意：是转换 不是桥接
var s = "String"
var ms = NSMutableString(string: s)

//: [Next](@next)
