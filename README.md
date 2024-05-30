# xidian_weather

这是一个使用 Flutter 构建的新项目。
作者: <chocolatedesue@outlook.com>

## 参考

1. 和风天气开发文档: <https://dev.qweather.com/docs/>
2. UI设计和应用原型大部分参考了这个应用 <https://github.com/MGAndroidProjects/WeatherWise-Releases>

## 快速开始

1. 克隆项目：`git clone xx`, 然后进入项目目录：`cd xx`
2. 在根目录下创建 `.env` 文件，按照 `.env.example` 文件的格式填写API密钥
3. 获取项目依赖：`flutter pub get`
4. 清理并构建项目：`dart run build_runner clean &&  dart run build_runner build --delete-conflicting-outputs`
5. 运行项目：`flutter run`

## 注意事项

1. API中可能存在空值，目前未作处理
2. iOS 和 macOS 的位置权限未声明
3. 组件的 `initstate` 不能声明为 `async`，否则无法加载
4. 字体颜色问题待解决
5. 若要复用action, 需要在github secret中添加APIKEY
6. 如果项目无法运行，可以尝试手动指定apikey

## 特性

1. 支持自选地域保存
2. 支持定位功能
3. 使用和风天气API
4. 对使用体验和外观进行了优化
5. 使用阿里云通义千问API，进行了智能问答

## 待办事项

1. API密钥目前是写死的，如果项目要公开，请记得修改
2. 安卓版本没有签名，可能会影响覆盖安装

## 截图
![alt text](assert/image.png)
![alt text](assert/image-1.png)
![alt text](assert/image-2.png)