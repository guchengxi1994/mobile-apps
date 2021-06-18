# password_store_app

## Getting Started

### 1. flutter pub get

### 2. flutter run

tip1:  如果浏览器运行有问题，请使用模拟器

#
# 为什么要用flutter

## 1. 火

### github上flutter 的 star数 12W+ , issue 数(包括解决的与未解决的) 接近6W,RN 的 star数 9.6W, issue 数(包括解决的与未解决的) 接近2W出头，weex 刚被 阿帕奇开源组织下架了，其社区活跃度相较于前两个不值一提。（阿里做什么都虎头蛇尾，包括fish-redux这个状态管理也太监了）

## 2.多端适配

### android ,ios,web适配（转js执行），windos跟linux也可以写(谷歌官方提供了Flutter-Desktop-Embedding，还有go-flutter——第三方的基于go语言的flutter桌面系统)，还有亲儿子 Fuchsia OS。据说flutter做的app fps能达到120，但是我不知道怎么测.

#
## 3.上手快

### 面向对象特性跟java如出一辙，懂java的学这个很快。反之，学会了这个再去学java未必会很很容易，但是学个python啥的基本就没难度了。其语言强类型，逻辑性强，所以跟大多数后端语言很像。（我在哪个文章上看到说dart是面向未来的编程语言，但是记不清楚了）

#
# 模拟器

## 模拟器推荐使用 网易 MUMU,这上面能顺利安装微信。

## 连接模拟器用这个命令

    adb connect 127.0.0.1:7555

## 然后就

    flutter run

## 但是MUMU上默认不会用GPU加速你的APP，运行的时候需要加参数

    flutter run  --enable-software-rendering 

## 不加的话你的app打开就是一片空白。

#
# null-safety

## 这是dart 2.12 新加进去的特性，主要是用于空值判断，减少空指针。但是这个特性用起来很不爽，尤其是你引入的包有部分不支持null-safety的时候就必须在编译的时候禁用这个特性。

    flutter run  --enable-software-rendering  --no-sound-null-safety

tip: 这个项目我用的 dart2.12写的，所以是null-safety的，但是我引用的包不是，所以只能禁用。

## 为什么我说它很傻呢，因为一般情况下，哪怕没有这个特性，代码基本不会有空指针（我），最多是内存溢出这种。

## null-safety 主要是加了一个关键字 late，在声明变量的时候，可以这么写：

    late ClassName param;

## late表示在之后会进行实例化

    ClassName? param

## ? 代表可能为空

    param!

## ! 代表非空

#
# FutureBuilder

## flutter 在引入状态管理（bloc,flutter-redux或者fish-redux）之前，要刷新页面需要使用 set state(){} 这个方法，一个页面刚创建过程中(执行 init state(){ ... } 再执行 build(){ ... } 方法)，由于build方法中不能执行 set state(){} , init state(){} 方法中如果执行异步操作（接口访问），那么可能 build执行完成之后都还没有 拿到用来渲染的数据，所以用 FutureBuilder 来 规避这个问题。一般的做法见下面的写法：

### 1. 定义一个异步操作

    Future\<T> methodName(args){
        ...
        retutn <T>t;
    } 

### 2. 定义future

    var _future = methodName(args);

### 3.因为 FutureBuilder 返回值是个 Widget 类型的控件，所以可以直接替代 build 方法中 return 后面的内容。当然，所有涉及到 Widget 的都可以用FutureBuilder代替，只要是不同的接口别的什么异步操作，这样就实现了一个很长的页面的异步。

    FutureBuilder(future:_future,builder:(context,snapshot){
        if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
                // 请求失败，显示错误
                return Center(
                    child: Text("Error: ${snapshot.error}"),
                );
            }else{
                // 正常build
                }
        else {
            return Center(
            // 这是一个圈圈滚动的样式
            child: CircularProgressIndicator(),
            );
    });

## context是上下文，自带的不用管。snapshot.data 就是函数返回的那个 T 类型的变量（也有可能是空或者error），snapshot.connectionState == ConnectionState.done 就是判断这个异步操作有没有做完，没做完就一直转圈圈。这里如果在 null-safety 模式下会比较复杂，因为 在使用 snapshot.data 的时候会进行类型判断，但是它不会认为这个data是 T 类型的，需要转换一下：

    t = snapshot.data as T

## 然后还会报个warning， 所以我觉得 null-safety 很蠢。

#
# 本地存储

## 一般用 sharedpreference 做本地缓存。这是一个官方组件，采用键值对的方法存储一些简单数据（int,string,boolean这样常见的），复杂的数据可能要用到sqlite或者后端。实例化以及存储是个异步过程

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int counter = prefs.getInt('counter');

    prefs.setInt("key",value);

## sqflite sqlite轻量级数据库的flutter版本。

https://pub.dev/packages/sqflite

## 官方案例写的比较全，跟后端操作数据库一样，建模，写sql crud,拿到数据后渲染 （经典的MVC）

#
# 动画

    def introduce_animation_to_you_gays: pass

#
# 状态管理（bloc）

https://www.jianshu.com/p/176eca4f8275

## 这一块我也是刚开始做，很多骚操作还没看到，只会写简单的 bloc.

# 其他

## 文件命名

Java 文件命名是与类名一样首字母大写驼峰式，一个文件一个类（单一原则），dart里边一般是全小写加下划线的命名方法。

## part of 

这个关键字代表这个dart是另一个dart的一部分，（参考bloc）