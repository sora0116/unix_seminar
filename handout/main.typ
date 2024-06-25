#set page(numbering: "1")
#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#outline(title: "目次")

#include "section1.typ"
#include "section2.typ"
#include "section3.typ"
#include "section4.typ"
= 停止と継続
デバッガを使用することでプログラムを停止することができます。

== ブレークポイント、ウォッチポイント、キャッチポイント
- ブレークポイント
プログラム中の特定の場所で、そこに到達すると停止する。
- ウォッチポイント
式の値が変化したときに停止する。
- キャッチポイント
例外やライブラリロードなどで停止する。

=== ブレークポイントの設定
ブレークポイントは`break, b`コマンドで設定できます。さらに変数`$bpnum`にブレークポイントの数が保存されています。

一つのブレークポイントが複数のコードの位置にマッピングされることがあります。例えばC++のtemplateやオーバーロードなど。その場合、設定時にその数を出力します。

デバッグ中のプログラムがブレークポイントに到達すると、変数`$_hit_bpnum`と`$_hit_locno`がセットされます。

`
	break, b
`
引数無しで`break`コマンドを実行すると、選択されたスタックフレームの次に実行される命令にブレークポイントが設置されます。
`
	break ... [-force-condition] if <cond>
`
条件付きブレークポイントを設定します。このブレークポイントに到達したとき、`cond`の式がゼロでない場合にプログラムは停止します。
`-force-condition`を指定すると、式`cond`が無効な式でもブレークポイントを設置します。
`
	tbreak args
`
一回限りのブレークポイントを設置します。引数は`break`と同じです。このブレークポイントに一回プログラムが到達するとそのブレークポイントは自動的に消去されます。
`
	hbreak args
`
ハードウェアブレークポイントを設置します。
`
	thbreak args
`
一回限りのハードウェアブレークポイントを設置します。
`
	rbreak <regex>
`
正規表現`regex`にマッチするすべての関数にブレークポイントを設置します。`regex`に`.`を指定すればすべての関数にブレークポイントを設置できます。
`
	rbreak <file>:<reex>
`
ファイル名を指定して`rbreak`を実行します。
`
	info breakpoints [list...]
	info break [list...]
`
全てのブレークポイント、ウォッチポイント、トレースポイント、キャッチポイントを表示します。
`list`を指定すると指定したものだけを表示できます。

ブレークポイントは共有ライブラリを読み込んだ場合などに再計算されます。また、共有ライブラリロード以前にブレークポイントを設定しておくことも可能です。
`
	set breakpoint pending auto
`
通常の動作です。GDBがロケーションを解決できない場合、作成するかどうかをユーザに問い合わせます。
`
	set breakpoint pending on
	set breakpoint pending off
`
onの場合、解決できなくても作成します。offではしません。
以上の設定はブレークポイントを設定するときにだけ適用されます。一度設置されたブレークポイントは自動で再計算されます。
`
	set breakpoint auto-hw 'on|off'
`
自動でハードウェアブレークポイントを使用するかどうかの設定です。
`
	set breakpoint always-inserted 'off|on'
`
offがデフォルト値です。プログラムが停止したときにブレークポイント用に書き換えたプログラムコードを元に戻すかどうかの設定です。

=== ウォッチポイントの設定
ウォッチポイントで監視できるものは以下の通りです。
- 単一の変数
- 適切なデータ型にキャストされたアドレス
- 式
ウォッチポイントはその計算が可能になる前から設定できます。そして有効な値になったときにプログラムを停止します。

=== キャッチポイントの設定
キャッチポイントを使用することでプログラムの例外や共有ライブラリロードなどのイベントによりデバッガに停止させることができます。

`
	catch <event>
`
`event`が発生すると停止します。イベントは以下の通りです。
`
	throw [regexp]
	rethrow [regexp]
	catch [regexp]
`
C++の例外が投げられた、再び投げられた、キャッチされた。
`regexp`が与えられている場合、その正規表現にマッチする例外だけがキャッチされます。
`
	syscall [name | number | group:groupname | g:groupname]
`
システムコール発行時または復帰。
`
	fork
	vfork
`
forkおよびvfork呼び出し
`
	load [regexp]
	unload [regexp]
`
共有ライブラリの読み込み、アンロード
`
	signal [signal... | 'all']
`
シグナル発行。
`
	tcatch
`
一回限りのキャッチポイントを設置

=== ブレークポイントの削除
`
	clear [locspec]
`
引数を指定しない場合、次の命令のブレークポイントを削除します。指定した場合、そのブレークポイントを削除します。
`
	delete [breakpoints] [list...]
`
引数で指定したブレークポイント、ウォッチポイント、キャッチポイントを削除します。引数を指定しない場合、すべて削除します。

=== ブレークポイントを無効にする
ブレークポイント、ウォッチポイント、キャッチポイントには以下の状態があります。
- 有効
	- 有効なブレークポイント。
- 無効
	- 無効なブレークポイント。
- 一度だけ有効
	- 一度プログラムが停止すると無効になる。
- 何回か有向
	- 指定した回数プログラムが停止すると無効化される。
- 有効のち削除
	- 一度プログラムが停止すると削除される。
`
	disable [breakpoints] [list...]
	enable [breakpoints] [list...]
`
指定したブレークポイントを無効化、有効化する。
disableは引数を指定しない場合、何もおこらない。enableは全て有効になる。
`
	enable [breakpoints] once <list...>
	enable [breakpoints] count <count> <list...>
	enable [breakpoints] delete <list...>
`
一度だけ有効、何回か有効、有効のち削除にする。

=== ブレーク条件
ブレークポイントには条件を付けてそれを満たす場合のみプログラムを停止することができます。
`
	condition [-force] <bnum> <expression>
`
bnumのブレークポイントに条件を付与します。`-force`オプションをつけると現時点で無効な式も使用できます。
`expression`を指定せずに実行すれば条件式を外すことができます。
`
	ignore <bnum> <count>
`
ブレークポイントに到達した`count`回は無視して、次からは停止します。

=== ブレークポイントコマンドリスト
ブレークポイントで停止したときに実行するコマンドを指定することができます。
`
	commands [list...]
	... <command-list> ...
	end
`
`list`で指定したブレークポイントにコマンドリストを割り付けます。削除するにはコマンドリストを指定せずに実行します。


=== 動的printf
動的printf`dprintf`ブレークポイントとprintfを組み合わせたようなコマンドです。
`
	dprintf <locspec>, <template>, <expression> [, <expression>...]
`
locspecで指定した場所にプログラムが到達すると`template`に従って式の`expression`を出力します。
`
	set dprintf-style <style>
`
dprintfの以下のスタイルを指定します。
- `gdb`
GDBのprintfのハンドル。`%V`の指定子が使える。
- `call`
ユーザプログラムの関数を使用します。通常は`printf`。`%V`は使えません。
- `agent`
リモートデバッグエージェントに出力させます。`%V`は使えません。
`
	set dprintf-function <function>
`
`call`のときに使用する関数を設定します。
`
	set dprintf-channel <channel>
`
`channel`に空でない値を設定すると、`fprintf-function`の第一引数にそれを与えて評価します。
`
	set disconnected-dprintf 'on|off'
`
`agent`のときに、ターゲットが切断されたときにdprintfの実行を続けるかどうかの設定です。

=== ブレークポイントをファイルに保存する方法
`
	save breakpoints [<filename>]
`

=== 静的プローブポイントの一覧表示
=== ブレークポイントを挿入できません。
=== ブレークポイントアドレスが調整されました...


== 継続とステップ
== 関数とファイルのスキップ
== シグナル
== スレッドストップ
