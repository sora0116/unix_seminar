= ソースファイルの検証

== リスト
`
	list <linenum>
`
`linenum`の行を中心に数行のソースコードを表示します。
`
	list <function>
`
関数の開始点を中心にコードを表示します。
`
	list [+|-|.]
`
`+`または引数なしの場合、最後に出力された行の続きを表示する。`-`では最後に出力された行の前を、`.`では選択中のフレーム内の実行ポイント周辺を表示する。
`
	set listsize <count>|'unlimited'
`
`list`で出力される行数を設定します。
`
	list <locspec>
`
`locspec`で指定した箇所を中心にソースコードを表示します。
`
	list [<first>], [<last>]
`
`first`から`last`までのソースコードを表示します。いづれかを省略すると最初からまたは最後までとなります。

== 位置指定
GDBコマンドでプログラムのコードの場所を指定できます。ここでは指定の方法について説明します。

=== linespec
linespecはファイル名や関数名などソース場所のパラメータをコロンで区切ったリストです。
`
	[filename:]linenum
`
ファイル名と行番号を指定します。filenameに相対ファイル名を指定すると、同じ末尾成分を持つファイルがマッチします。ファイル名を指定しない場合、現在のファイルが指定されます。
`
	-offset
	+offset
`
現在の行からの相対位置で指定します。
`
	[filename:]function[:label]
`
ファイル名、関数名、ラベルを指定します。`filename`内にある関数`function`の`label`がある行が指定されます。`label`を指定しない場合、関数本体の開始業が指定されます。C言語では中括弧はじめのある行が指定されます。
`
	label
`
ラベルのみを指定します。この場合、現在のスタックフレームに対応する関数内の`label`の位置を指定します。

=== 明示的位置
オプションと値を使って指定する方法です。
`
	-source <filename>
`
ファイル名を指定します。`-line`または`-function`を併用する必要があります。
`
	-function <function>
`
関数を指定します。
`
	-qualified
`
`-function`で指定された関数名を完全修飾名として解釈します。
`
	-label
`
ラベルを指定します。
`
	-line <number>
`
行数を指定します。絶対値(符号なし)と相対値(符号あり)が指定できます。

=== アドレス位置
コードアドレスを指定する方法です。
`
	expression
`
現在の作業言語で有効な式が受け付けられます。
`
	['filename':]funcaddr
`
関数のアドレスです。C言語では単に関数名です。ファイル名を指定することもできます。

== 編集
ソースファイルの行を編集できます。
`
	edit <locspec>
`
`locspec`で指定した行を指定したプログラムで編集できます。

=== エディタを変更する
環境変数`EDITOR`にエディタを指定すると`edit`で開かれるエディタを指定できます。

== 検索
正規表現でファイルを検索できます。
`
	forward-search <regexp>
	search <regexp>
	fo <regexp>
`
最後にリストされた行の次の行から前向きに検索できます。見つかった行はリストされます。
`
	reverse-search <regexp>
	rev <regexp>
`
逆順に検索します。

== ソースパス
`
	directory [<dirname>...]
	dir [<dirname>...]
`
ソースパスに`dirname`を追加します。引数なしで実行するとソースパスをリセットできます。
`
	set directories <path-list>
`
ソースパスを`path-list`に設定します。`$cdir:$cwd`がない場合は追加されます。
`
	set substitute-path <from> <to>
`
ソースパスの`from`を`to`に置換し、最後に追加します。
`
	unset substitute-path [path]
`
パスが指定されている場合、そのパスを書き換えるルールを現在の置換ルールのリストから検索し、見つかった場合は削除します。
パスを指定しない場合、すべて削除されます。

== 機械語
`
	info line [<locspec>]
`
指定した(指定しない場合は現在の)行のコンパイル済みコードの開始アドレスと終了アドレスを表示します。`info line`のあともう一度同コマンドを実行すると次のソース行の情報が表示される。
`
	disassemble ['/m|/s|/r|/b']
`
メモリの範囲をマシンコードとしてダンプします。`/m, /s`はソースとマシン命令を、`/r, /b`は生の命令を表示します。`\m`は非推奨です。
`
	set disassembler-options <option1>[,<option2>...]
`
ターゲット固有の情報を逆アセンブラに渡す設定です。

== ソース読み込み無効化
`
	set source open ['on|off']
`
GDBがソースコードへアクセスできるかどうかの設定です。デフォルトでは`on`です。
