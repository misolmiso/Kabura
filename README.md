#Kabura

WebSocketとPythonとCoffeeScriptで、
スマートフォンで遊べるゲームを作ろうとするもの

##Requires
*Python >= 3.2
*virtualenv
*npm
*grunt-cli

##Build and Run
$ cd /path/to/Kabura  
$ cd client  
$ npm install  
$ grunt  
$ cd ../server  
$ virtualenv -p python3 .  
$ source ./bin/activate  
$ pip install -r packages.txt  
$ ./server  
localhost:8000にブラウザで接続  
(ポート番号の変更はKabura/server/server内を書き換える)  
