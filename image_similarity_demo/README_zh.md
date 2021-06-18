# flutter 中的 dio —— 不做人了

## flutter/dart 中有自带的http请求包 "dart:io"，但是封装的并不好，很多功能都不完善，比如下载上传。所以用这个国人出的工具包（支持国产，并且确实很好用，基本功能都有）。

# 1. 基本使用

## 1.1 前言

## 基本工具 https://javiercbk.github.io/json_to_dart/ ，这是一个将 json格式 字符串转换为 dart 的实体类工具。

eg.

    {
        "code": 20000,
        "data": {
            "name": "张三",
            "age": 120,
            "gender": "unknow"
        }
    }

#
    class Person {
    int code;
    Data data;

    Person({this.code, this.data});

    Person.fromJson(Map<String, dynamic> json) {
        code = json['code'];
        data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['code'] = this.code;
        if (this.data != null) {
        data['data'] = this.data.toJson();
        }
        return data;
    }
    }

    class Data {
    String name;
    int age;
    String gender;

    Data({this.name, this.age, this.gender});

    Data.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        age = json['age'];
        gender = json['gender'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['age'] = this.age;
        data['gender'] = this.gender;
        return data;
    }
    }

## 注意，dart 2.12版本以后要做非空判断（加？），不过这边的工具还没有支持。这里的实体类自动实现了两个方法 toJson() 以及 fromJson(),因为api接口一般是以json格式返回，所以fromJson就相当于可以将 json字符串转化为这个类型的对象，便于取值；toJson() 可以用在request请求的时候将这个对象转为json格式。

#
## 1.2 基本请求

    // 实例化
    Dio dio = Dio();

    // 声明 url
    String url = "http://192.168.50.99:3334/compare";

    // 声明 请求对象并赋值（可以自己拼接json字符串，但是我比较喜欢面向对象解决问题）
    Req req = Req();

    // dart 转 json
    String jbrJson = json.encode(req.toJson());

    // 请求（这个Response 类是 Dio包下的，不要引用错了，这是一个post方法）
    Response response = await dio.post(url, data: jbrJson);

    // 获取结果
    var result = response.data;

    // 转成结果对象（要做空值判断，状态码判断）
    Resp resp = Resp.fromJson(json.decode(result));

    // 后续界面操作

## 1.3 这样做可以，但是存在不足之处，就是每次都要声明一个新的Dio对象（不是单例，拒绝OOM，从我做起，从小事做起）,同时没有异常处理，每次都要自己判断状态码，所以这里要对这个进行改造。

#
# 2.进阶使用

## 2.1 封装 Dio

    class DioUtil {
    /// 这里实现的是单例模式
    static DioUtil _instance = DioUtil._internal();
    factory DioUtil() => _instance;
    Dio _dio;

    DioUtil._internal() {
        if (null == _dio) {
        _dio = new Dio();
        _dio.interceptors.add(LoginInterceptors());
        }
    }

    /// 这里是拦截器，2.2里边再讲
    addInterceptors(Interceptor i) {
        _dio.interceptors.clear();
        _dio.interceptors.add(i);
    }

    ///get请求方法
    get(url, {params, options, cancelToken}) async {
        Response response;
        try {
        response = await _dio.get(url,
            queryParameters: params, options: options, cancelToken: cancelToken);
        } on DioError catch (e) {
        print('getHttp exception: $e');
        formatError(e);
        }
        return response;
    }

    ///put请求方法
    put(url, {data, params, options, cancelToken}) async {
        Response response;
        try {
        response = await _dio.put(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken);
        } on DioError catch (e) {
        print('getHttp exception: $e');
        formatError(e);
        }
        return response;
    }

    ///post请求
    post(url, {data, params, options, cancelToken}) async {
        Response response;
        try {
        response = await _dio.post(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken);
        } on DioError catch (e) {
        print('getHttp exception: $e');
        formatError(e);
        }
        return response;
    }

    //取消请求
    cancleRequests(CancelToken token) {
        token.cancel("cancelled");
    }


    /// 这里是异常捕获后前端展示
    /// dio 一个内置了 5 种错误类型
    void formatError(DioError e) {
        if (e.type == DioErrorType.connectTimeout) {
        print("连接超时");
        Fluttertoast.showToast(
            msg: "连接超时",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        } else if (e.type == DioErrorType.sendTimeout) {
        print("请求超时");
        Fluttertoast.showToast(
            msg: "请求超时",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        } else if (e.type == DioErrorType.receiveTimeout) {
        print("响应超时");
        Fluttertoast.showToast(
            msg: "响应超时",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        } else if (e.type == DioErrorType.response) {
        print("出现异常");
        Fluttertoast.showToast(
            msg: "返回结果异常",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        } else if (e.type == DioErrorType.cancel) {
        print("请求取消");
        Fluttertoast.showToast(
            msg: "请求取消",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        } else {
        print("未知错误");
        Fluttertoast.showToast(
            msg: "无法连接服务器",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        }
    }
    }

## 以上是完成了一个单例模式的dio, 但是还是没有完成 统一的 拦截器，所以下一步就是介绍拦截器。

#
## 2.2 dio中的拦截器

拦截器的定义跟 Java 里边的过滤器 拦截器都差不多或者python里边的装饰器。


    class LoginInterceptors extends Interceptor {
    int _resultCode;

    LoginInterceptors();

    @override
    void onRequest(
        RequestOptions options, RequestInterceptorHandler handler) async {
        if (options.path.contains("token")) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var _token = prefs.getString("token");
        if (null == _token) {
            _token = '';
        }
        options.path = options.path + _token;
        }

        super.onRequest(options, handler);
    }

    @override
    void onError(DioError err, ErrorInterceptorHandler handler) {
        // TODO: implement onError
        super.onError(err, handler);
    }

    @override
    Future onResponse(
        Response response, ResponseInterceptorHandler handler) async {
        var responseJson = response.data;
        if (responseJson.runtimeType == String) {
        responseJson = jsonDecode(responseJson);
        }
        CommenResponse commenResponse = CommenResponse.fromJson(responseJson);
        _resultCode = commenResponse.code;

        /// token过期,未授权的情况
        if (ResCodes.needsLogin.contains(_resultCode)) {
        NavigatorState navigatorState = Global.navigatorKey?.currentState;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (navigatorState != null) {
            var _trigged = prefs.getInt("trigged");
            if (null == _trigged) {
            _trigged = 0;
            await prefs.setInt("trigged", _trigged);
            }
            if (_trigged == 0) {
            await prefs.setInt("trigged", _trigged + 1);
            Fluttertoast.showToast(
                msg: "当前登陆状态已失效，请重新登陆",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.orange,
                textColor: Colors.white,
                fontSize: 16.0);

            navigatorState.push(MaterialPageRoute(
                builder: (context) => LoginPage(
                        withAppBar: true,
                    )));
            } else {
            await prefs.setInt("trigged", _trigged + 1);
            }
        }
        } else if (_resultCode == 40000) {
        Fluttertoast.showToast(
            msg: "网络请求异常",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
            fontSize: 16.0);
        } else {
        return super.onResponse(response, handler);
        }
    }
    }

#
## 这里是访问接口之前从缓存中拿token，然后访问接口之后根据返回的code判断状态，如果token还可以用的话就完成下面的操作，如果token失效则跳转登录页。

## 那么问题来了，普通的跳转是需要 context 上下文信息的，不可能每次声明dio 就把这个拦截器加进去，那么每个页面会增加很多无厘头代码，所以下面就要讲无上下文跳转。

#
# 3. 无上下文 context 跳转

    // 声明一个全局的 key
    static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

    // 使用
    // 拿到这个key
    NavigatorState navigatorState = Global.navigatorKey?.currentState;

    // 跳转
    navigatorState.push(MaterialPageRoute(
              builder: (context) => LoginPage(
                    withAppBar: true,
                  )));
    
## 这样，就可以在拦截器里边完成跳转，而不用关心当前页面是哪个。

## dio下还有很多配置，比如设置超时时间啥的，不过这里用不到，有兴趣的可以自己去看看他们的github.  https://github.com/flutterchina/dio/blob/master/README-ZH.md

#
# 4. 权限（以android为例）

## 4.1 flutter 的不同调试方案

## flutter一共有三种调试方案，debug,release,以及profile,后两者可以统一用release进行调试，profile用的不多。debug编译出来的安装包一般来说（也有例外）比release包大，因为debug里边多很多 assert 断言，打包没做混淆，产生很多debug信息，新能比较差；release包不会去执行assert，也不会产生很多log,但是请删掉代码中涉及隐私的 print() 方法，不然人家很有可能获取用户信息（还有反编译，不过flutter默认在编译的时候混淆，所以反编译成本很高）。

## 为什么要讲这个呢，因为debug模式下，权限会自动获取，不用动态申请。

# 
## 4.2 android 权限申请

## 要修改 项目 android 文件夹下配置文件。（具体在./android/app/main/AndroidManifest.xml）,这个文件同时关联启动页（原生android应用都要在这里声明启动页activity，app的名字以及图标）

    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.tasknetwork.zhixiaoxia">

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <!-- 这个权限用于进行网络定位 -->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <!-- 这个权限用于访问GPS定位 -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>



        <application
        android:requestLegacyExternalStorage="true"
            android:largeHeap="true"
            android:name=".MapApplication"
            <!-- android哪个版本之后不允许访问 http，只允许https，这个xml是用来声明允许访问 http 请求的 -->
            android:networkSecurityConfig="@xml/network_security_config"
            android:icon="@mipmap/ic_launcher"
            android:label="职小侠"
            android:roundIcon="@mipmap/ic_launcher_round"> <!-- 添加对于圆形 Icon 支持 -->
            <meta-data
            android:name="com.baidu.lbsapi.API_KEY"
            android:value="M396CNPZMi58lOPcKqhNMjCcHEQomraP" />
            <activity
                android:name=".MainActivity"
                android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
                android:hardwareAccelerated="true"
                android:launchMode="singleTop"
                android:theme="@style/LaunchTheme"
                android:windowSoftInputMode="adjustResize">
                <!-- Specifies an Android theme to apply to this Activity as soon as
                    the Android process has started. This theme is visible to the user
                    while the Flutter UI initializes. After that, this theme continues
                    to determine the Window background behind the Flutter UI. -->
                <meta-data
                    android:name="io.flutter.embedding.android.NormalTheme"
                    android:resource="@style/NormalTheme" />
                <!-- Displays an Android View that continues showing the launch screen
                    Drawable until Flutter paints its first frame, then this splash
                    screen fades out. A splash screen is useful to avoid any visual
                    gap between the end of Android's launch screen and the painting of
                    Flutter's first frame. -->
                <meta-data
                    android:name="io.flutter.embedding.android.SplashScreenDrawable"
                    android:resource="@drawable/launch_background" />
            
                <!-- <meta-data
                    android:name="io.flutter.app.android.SplashScreenUntilFirstFrame"
                    android:value="true" /> -->
                <intent-filter>
                    <action android:name="android.intent.action.MAIN" />
                    <category android:name="android.intent.category.LAUNCHER" />
                </intent-filter>
            </activity>
            <!-- Don't delete the meta-data below.
                This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
            <meta-data
                android:name="flutterEmbedding"
                android:value="2" />
            
            <provider
                android:name="sk.fourq.otaupdate.OtaUpdateFileProvider"
                android:authorities="${applicationId}.ota_update_provider"
                android:exported="false"
                android:grantUriPermissions="true">
                <meta-data
                    android:name="android.support.FILE_PROVIDER_PATHS"
                    android:resource="@xml/filepaths" />
            </provider>
        </application>
    </manifest>

# 4.3 android 修改包名

## （1）修改文件夹名

## （2）修改AndroidManifest.xml文件中涉及到的包名

## （3）修改 build.gradle 中的 applicationId

## 这个主要是用来在一些开放平台注册app过程中，要拿这个app的md5或者sha1值，可改可不改，不改的话默认是 "com.example.xxx"，这个就不像是正儿八经app的包名。

# 4.4 动态申请权限

## 修改xml文件只是声明你要这些权限，后边要用的时候还要动态申请（不申请不给用，容易给人举报），flutter 用 permission_handler 动态申请权限（这个包新版本变动很大，现在出到 8 了，我还是用的5，主要是网上的教程5 的最多，而且8 跟百度地图的sdk不搭。）

    if (await Permission.storage.request().isGranted){
        // TODO
    }

## 以上是动态申请读取存储的代码，这个如果没有权限会弹个弹窗出来，如果同意就可以使用权限，如果不同意下次继续弹这个弹窗。弹窗是android自己的组件，原生android可以改样式，flutter里边没玩过。