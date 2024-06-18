#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#outline(title: "目次")

= デバッガ
プログラムのバグ(bug)を取り除く(de-)ことをデバッグといいます。デバッグを行う手法はいくつかあり、例えばプログラム中に標準出力を行う命令を追加してデバッグを行うprintデバッガと呼ばれる方法があります。デバッガはデバッグを支援するツールで、プログラムの任意箇所での停止や、変数の値の表示や変更、スタックトレースやメモリ内容の監視など高度な機能によりデバッグを支援します。

C言語で書かれたプログラムに対応するデバッガはいくつか存在しており、有名なものにGDBとLLDBが存在します。このドキュメントではこの二つのデバッガについて基本的な使用方法の解説を行います。

= GDB
GDBはGnu Projectのデバッガです。

== GDBの起動
GDBを起動するには以下のいづれかのコマンドを使用します。起動後はコマンドを受け付けます。
`
	gdb [options] [executable-file [core-file or process-id]]
	gfb [options] --args <executable-file> [inferior-arguments ...]
`
`--args` を指定する場合、実行可能ファイルの後の引数(inferior-arguments) が実行時に渡されます。例えば `gdb --args gcc -O2 -c foo.c` は `gcc -O2 -c foo.c` の実行にデバッガをアタッチします。

optionsに指定できるオプションは `gdb -h` で確認できます。

== GDBの終了
GDBを終了するには `quit [expression]`, `exit [expression]` または `q` で終了できます。`expression` に指定した値は終了コードとして帰ります。

== シェルコマンド
GDB起動中にシェルコマンドを使用することができます。
`
	shell <command-string>
	!<command-string>
`
`pipe` 命令を使用してgdbの出力を他のプログラムに繋ぐことができます。
`
	pipe [command] | <shell_command>
	| [command] | <shell_command>
	pipe -d <delim> <command> <delim> <shell_command>
	| -d <delim> <command> <delim> <shell_command>
`
`command` が `|` を含むときには -d で別の記号(列)を指定します。

== ロギング出力
GDBの出力をファイルに行うことができます。GDBにはロギングを制御するコマンドがいくつか用意されています。

/ `set loggging enabled [on|off]`: ロギングのオンオフ切り替え
/ `set logging file <file>`: 現在のログファイルの名前を変更。デフォルト値は `gdb.txt`
/ `set logging overwrite [on|off]`: 上書きか書き足しか(onで上書き)。デフォルト値は `off`
/ `set logging redirect [on|off]`: onにするとGDBの出力がログファイルにのみ行われる。デフォルト値は `off`
/ `set logging debugredirect [on|off]`: onにするとGDBデバッグの出力がログファイルにのみ行われる。デフォルト値は `off`
/ `show logging`: ロギングの設定を表示する

= GDBコマンド
