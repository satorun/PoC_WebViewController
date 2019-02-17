//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        
        
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


protocol Context {}
protocol InheritedContext: Context {}
extension Int: Context, InheritedContext {}
extension String: Context, InheritedContext {}

// generic変数を持った型を継承する場合
// 1. 型を指定したものを継承する
// 2. 継承元のgeneric変数（の条件を満たす)をもった形で継承する
// ということができる
class Base<T: Context> {
    let variable: T
    
    init(variable: T) {
        self.variable = variable
    }
}
class Inherited: Base<Int> {}
let instance = Inherited(variable: 5)
// type error
//let instance2 = Inherited(variable: "string")

class Standard<T: Context>: Base<T> {}
let instance_Int = Standard(variable: 5)
let instance_String = Standard(variable: "string")

class Specified<T: InheritedContext>: Base<T> {}
let instance_Int2 = Specified(variable: 1)
let instance_String2 = Specified(variable: "string")




