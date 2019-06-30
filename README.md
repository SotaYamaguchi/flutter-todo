# Flutter Sample
TODOアプリ Flutter/Firebase勉強会用

# Getting Started

***Flutter SDKのインストール：***

https://flutter.dev/docs/get-started/install/macos


# Flutter プロジェクトの作成

今回はネイティブ言語をswiftとkotlinに設定
```
$ flutter create -i swift -a kotlin --with-driver-test flutter_sample
```


# 起動

```
$ cd flutter_sample
$ flutter run
```


# Firebaseの導入

firebaseにプロジェクトを登録

https://firebase.google.com/?hl=ja


***firebaseの実装***

こちらを参考に：

https://firebase.google.com/docs/flutter/setup?hl=ja


下記のファイルは.ignoreしているのでそれぞれダウンロードして配置してください。
GoogleService-Info.plist
google-services.json


***iOS編 注意事項：***

設定ファイル「GoogleService-Info.plist」をダウンロードしXcodeからRunnerフォルダ内に追加するところ。

*Finderでファイルを配置しただけだとプロジェクトに読み込まれないので注意
