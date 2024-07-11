#import "@preview/big-todo:0.2.0": *

#set text(font: "Harano Aji Mincho")
#set heading(numbering: "1.1")
#set page(numbering: "1")

#show raw: it => {
  if (it.lang == "shell") {
    block(fill: rgb("#1d2433"), width: 100%, inset: 10pt, radius: 10pt)[
      #text(fill: rgb("#f6f6f6"))[#it]
    ]
  } else {
    it
  }
}

#let lldb(cmd) = raw("  (lldb) "+cmd, block: true, lang: "shell")
#let options(pre: [文法:], name: "option name", desc: "description", ..con) = {
  pre
  table(
    columns: (2fr, 3fr),
    align: (_, y) => if y==0 {center} else {left},
    [#name], [#desc],
    ..con.pos().flatten()
  )
}
#let sep(text) = table.cell(colspan: 2)[#align(center)[#text]]
#let syn(text) = raw("  (lldb) "+text, block: true, lang: "shell")

#align(center+horizon)[#text(size: 2em)[LLDB]]
#align(center)[Chapter 2]
#counter(heading).update(0)
#pagebreak()

= 概要
	= LLDBとは
		LLDBはLLVMのデバッガです。
	= コマンド
		LLDBを起動すると先頭に`(lldb)`の表示が出て対話モードになります。
		#lldb("<noun> <verb> [<options>]")
		の形式でコマンドを実行し、様々の処理を行うことでデバッグを行います。

		コマンド入力時はTABによる補完が可能です。また、曖昧さがない場合にはコマンドは先頭数文字だけの入力でも認識されます。
	= ヘルプ
			コマンドのヘルプを`help`で確認できます。
			#syn("help [-ahu] [<command>...]")
			#options(
				(`-a, --hide-aliases`, [エイリアスを非表示]),
				(`-h, --show-hidden-commands`, [`-`から始まる隠しコマンドを表示]),
				(`-u, --hide-user-commands`, [ユーザー定義コマンドを非表示]),
				(`command`, [ヘルプを表示するコマンドを指定]),
			)
			`help -au`でコマンドの一覧を閲覧できます。
= 基本操作
	== LLDBの起動
		LLDBを起動するには以下のコマンドをシェルで叩きます。
		```shell
			$ lldb [<options>] [<program>]
		```
	== プログラムの読み込み
		デバッグするプログラムをGDBに読み込むには起動時の引数で指定するか、コマンドで指定することができます。

		起動時には例えば
		```shell
			$ lldb ./a.out
		```
		のように指定し、コマンドでは
		#lldb("target create ./a.out")
		のように指定できます。
	== プログラムの起動
		プログラムを起動するには`process launch`を使用します。
		#syn("process launch [<options>]")
		#options(
			(`-s, --stop-at-entry`, [エントリポイントで停止]),
			(`-n, --no-stdio`, []),
			(`-A, --disable-aslr <bool>`, [アドレスランダム化を行うか]),
			(`-e, --stderr <file>`, [標準エラー出力を指定]),
			(`-i, --stdin <file>`, [標準入力を指定]),
			(`-o, --stdout <file>`, [標準出力を指定]),
		)
		全てのオプションは`help process launch`で確認できます。
	== プログラムの終了
		プログラムを停止せずにトレース終了するには`ctrl+c`を使用するか`process kill`コマンドを使用します。
	== LLDBの終了
		LLDBを終了するには`ctrl+d`を使用するか`quit`コマンドで終了できます。
= プログラムの停止
  デバッグ中のプログラムを停止させるにはあらかじめ停止場所や条件を設定しておく必要があります。停止箇所としてはブレークポイント、ウォッチポイントが設定できます。
	== ブレークポイント
		プログラムが到達した際に停止する場所です。
		=== ブレークポイントの設置
			ブレークポイントを設置するには`breakpoint set`コマンドを使用します。
			#syn("breakpoint set [<options>]")
			#options(
				sep(""),
				(`-A, --all-files`, [全てのファイルを検索]),
				(`-D, --dummy-breakpoints`, [ダミーのブレークポイントを設置]),
				(`-H, --hardware`, [ハードウェアブレークポイントを使用]),
				(`-d, --disable`, [無効化されたブレークポイントを設置]),
				sep(""),
				(`-l, --line <linenum>`, [行番号`linenum`を指定]),
				(`-a, --address <addr>`, [アドレス`addr`を指定]),
				(`-n, --name <func>`, [関数名`func`を指定]),
				(`-F, --fullname <name>`, [関数の完全修飾名を指定]),
				(`-S, --selector <selector>`, [Objective-Cのセレクタ名を指定]),
				(`-M, --method <method>`, [C++のメソッド名を指定]),
				(`-r, --func-regex <reg>`, [正規表現`reg`にマッチする関数名を持つ関数を指定]),
				(`-b, --basename <func>`, [関数の基本名が`func`の関数を指定(C++の名前空間や引数)を無視]),
				(`-p, --source-pattern-regex <reg>`, [指定したファイル内のソースコードで正規表現にマッチする箇所を指定]),
				(`-E, --language-exceprion <lang>`, [指定した言語の例外スローを指定]),
				(`-y, --joint-specifier <linespec>`, [`filename:line[:column]`の形式でファイルと行を指定]),
				sep(""),
				(`-k, --structured-data-key <none>`, [スクリプトによるブレークポイントの実装に渡されるキーと値のペアのキー。 ペアは複数指定できます。]),
				(`-v, --structured-data-value <none>`, [スクリプトによるブレークポイントの実装に渡されるキーと値のペアの値。 ペアは複数指定できます。]),
				(`-G --auto-continue <bool>`, [コマンド実行後自動で再開]),
				(`-C, --command <cmd>`, [停止時に自動実行するコマンド]),
				(`-c, --condition <cond>`, [条件式`cond`を満たすときだけ停止]),
				(`-i, --ignore-count <n>`, [ブレークポイントを無視する回数]),
				(`-o, --one-shot <bool>`, [一度停止したら削除]),
				(`-q, --queue-name <name>`, [指定したキューに入っているスレッドのみ停止]),
				(`-t, --thread-id <tid>`, [指定したスレッドのみ停止]),
				(`-x, --thread-index <tidx>`, [指定したインデクスのスレッドのみ停止]),
				(`-T, --thread-name <name>`, [指定したスレッドのみ停止]),
				(`-R, --address-slide <addr>`, [指定されたオフセットを、ブレークポイントが解決するアドレスに追加します。現在のところ、これは指定されたオフセットをそのまま適用し、命令境界に整列させようとはしません。]),
				(`-N, --breakpoint-name <name>`, [ブレークポイントの名前]),
				(`-u, --column <col>`, [列を指定]),
				(`-f, --file <filename>`, [検索するファイルを指定]),
				(`-m, --move-to-nearest-code <bool>`, [一番近いコードへブレークポイントを移動]),
				(`-s, --shlib <name>`, [共有ライブラリを指定]),
				(`-K, --skip-prologue <bool>`, [プロローグをスキップ]),
			)
		=== ブレークポイントの削除
			ブレークポイントを削除するには`breakpoint delete`コマンドを使用します。
			#syn("breakpoint delete [<breakpoint-id>]")
			`breakpoint-id`の値は`breakpoint list`で確認できます。
			ブレークポイントを指定せずに実行すればすべてのブレークポイントを対象にできます。
		=== ブレークポイントの無効化
			ブレークポイントを無効化するには`breakpoint disable`コマンドを使用します。
			#syn("breakpoint disable [<breakpoint-id-list>]")
			ブレークポイントを指定せずに実行すればすべてのブレークポイントを対象にできます。
		=== ブレークポイントの有効化
			ブレークポイントを有効化するには`breakpoint enable`コマンドを使用します。
			#syn("breakpoint enable [<breakpoint-id-list>]")
			ブレークポイントを指定せずに実行すればすべてのブレークポイントを対象にできます。
		=== ブレークポイント到達時実行コマンド
			ブレークポイントに到達した際に実行するコマンドを`breakpoint command`コマンドで管理できます。
			#syn("breakpoint command <subcommand> [<options>]")
			`subcommand`には`add`, `delete`, `list`を指定できます。
			==== add
				コマンドを追加します。
				#syn("breakpoint command add [<options>] <breakpoint-id>")
				#options(
					(`-o, --one-liner <command>`, [コマンドを指定]),
				)
			==== delete
				コマンドを削除します。
				#syn("breakpoint command delete <breakpoint-id>")
			==== list
				設定されたコマンドの一覧を表示します。
				#syn("breakpoint command list <breakpoint-id>")
		=== ブレークポイントの保存
			ブレークポイントをファイルに保存するには`breakpoint write`コマンドを使用します。
			#syn("breakpoint write [<options>] [<breakpoint-id-list>]")
			#options(
				(`-a, --append`, [保存先ファイルが既存の場合、書き加える]),
				(`-f, --file <file>`, [保存先のファイルを指定]),
			)
			ブレークポイントを指定しない場合、すべてのブレークポイントを対象とします。
		=== ブレークポイントの読み込み
			`write`で保存したブレークポイントを読み込むには`breakpoint read`コマンドを使用します。
			#syn("break read [<options>]")
			#options(
				(`-N, --breakpoint-name <name>`, [名前を指定してその名前付きのブレークポイントのみ読み込む]),
				(`-f, --file <file>`, [読み込み元のファイルを指定]),
			)
			ブレークポイントを指定しない場合、すべてのブレークポイントを対象とします。
	== ウォッチポイント
		式の値を監視して変更があった際にプログラムを停止させます。
		=== ウォッチポイントの設置
			ウォッチポイントの設置には`watchpoint set`コマンドを使用します。
			#syn("watchpoint set <subcommand> [<options>] -- <varname>|<expr>")
			`subcommand`には`variable`と`expression`が指定でき、それぞれ変数、式の監視を行います。
			#options(
				(`-s, --byte-size <size>`, [監視する値のメモリサイズを指定]),
				(`-w, --watch-type <type>`, [ウォッチタイプを指定。`read|write|read_write`が指定可能]),
			)
		=== ウォッチポイントの削除
			ウォッチポイントを削除するには`watchpoint delete`コマンドを使用します。
			#syn("watchpoint delete [<watchpoint-id-list>]")
			`watchpoint-id`の値は`watchpoint list`で確認できます。
			ウォッチポイントを指定せずに実行すればすべてのウォッチポイントを対象にできます。
		=== ウォッチポイントの無効化
			ウォッチポイントを無効化するには`watchpoint disable`コマンドを使用します。
			#syn("watchpoint disable [<watchpoint-id-list>]")
			ウォッチポイントを指定せずに実行すればすべてのウォッチポイントを対象にできます。
		=== ウォッチポイントの有効化
			ウォッチポイントを有効化するには`watchpoint disable`コマンドを使用します。
			#syn("watchpoint enable [<watchpoint-id-list>]")
			ウォッチポイントを指定せずに実行すればすべてのウォッチポイントを対象にできます。
		=== ウォッチポイント到達時実行コマンド
			ウォッチポイントに到達した際に実行するコマンドを`watchpoint command`コマンドで管理できます。
			#syn("watchpoint command <subcommand> [<options>]")
			`subcommand`には`add`, `delete`, `list`を指定できます。
			==== add
				コマンドを追加します。
				#syn("watchpoint command add [<options>] <watchpoint-id>")
				#options(
					(`-o, --one-liner <command>`, [コマンドを指定]),
				)
			==== delete
				コマンドを削除します。
				#syn("watchpoint command delete <watchpoint-id>")
			==== list
				設定されたコマンドの一覧を表示します。
				#syn("watchpoint command list <watchpoint-id>")
= プログラムの再開
  ブレークポイント等で停止したプログラムを様々な方法で再開できます。再開方法は主にステップ実行と継続実行に分かれ、ステップ実行では一定分だけ進んで停止し、継続実行では次のブレークポイントまで進みます。
	=== 継続実行
		継続実行をするには`thread continue`コマンドを使用します。
		#syn("thread continue [<thread-index> ...]")
		`thread-index`を指定するとそのスレッドのみ継続実行できます。指定しない場合全てのスレッドが対象となります。`thread-index`の値は`thread list`コマンドで確認できます。
	=== 関数から帰る
		関数から帰るには`thread step-out`コマンドを使用します。
		現在選択中のフレームが帰るまで実行します。フレームの選択方法は @frame_lldb を参照してください。
		#syn("thread step-out [<thread-index>]")
	=== ソース行単位ステップオーバー
		ソース行単位ステップオーバーをするには`thread step-over`コマンドを使用します。
		#syn("thread step-over [<thread-index>]")
	=== 命令単位ステップオーバー
		命令単位ステップオーバーをするには`thread step-inst-over`コマンドを使用します。
		#syn("thread step-inst-over [<thread-index>]")
	=== ソース行単位ステップイン
		ソース行単位ステップインをするには`thread step-in`コマンドを使用します。
		#syn("thread step-in [<thread-index>]")
		ソース行単位ステップインをするには`thread step-in`コマンドを使用します。
		#syn("thread step-in [<thread-index>]")
	=== 命令単位ステップイン
		命令単位ステップインをするには`thread step-inst`コマンドを使用します。
		#syn("thread step-inst [<thread-index>]")
	=== until
		特定の箇所まで実行したい場合には`thread until`コマンドを使用します。
		#syn("thread until [<options>] <linenum>")
		#options(
			(`-a, --address <addr>`, [停止箇所のアドレスを指定]),
			(`-f, --frame <frame-index>`, [`until`の実行フレーム番号を指定]),
		)
= スタックフレーム
	== バックトレース
		コールスタックを表示するには`thread backtrace`コマンドを使用します。
		#syn("thread backtrace")
	== フレームの選択 <frame_lldb>
		フレームを選択するには`frame select`コマンドを使用します。
		#syn("frame select [<options>] [<frame-index>]")
		#options(`-r, --relative <offset>`, [選択中のフレームからのオフセットで選択])
	== フレーム情報の表示
		フレーム情報を表示するには`frame info`コマンドを使用します。
		#syn("frame info")
= 変数の表示
	変数を表示するには`frame variable`
	#syn("frame variable [<options>]")
	#options(
		(`-A, --show-all-children`, [上限を無視して子を表示]),
		(`-D, --depth <count>`, [表示する最大深さ]),
		(`-F, --flat`, [フラットフォーマットで表示]),
		(`-G, --gdb-format`, [GDBフォーマットで表示]),
		(`-L, --locationn`, [位置情報を表示]),
		(`-O, --object-description`, [言語ごとの説明APIを使用して表示]),
		(`-P, --ptr-depth <count>`, [値をダンプする際のポインタの深さ]),
		(`-R, --raw-output`, [フォーマットを行わない]),
		(`-S, --synthetic-type <bool>`, [synthetic providerに従うかを表示]),
		(`-T, --show-types`, [型を表示]),
		(`-V, --validate <bool>`, [型チェックの結果を表示]),
		(`-Y [<count>], --no-summary-depth=[<count>]`, [概要情報を省略する深さ]),
		(`-Z, --element-count <count>`, [型が配列あるかのように表示]),
		(`-a, --no-args`, [関数の引数を省略]),
		(`-c, --show-declaration`, [変数の宣言情報を表示]),
		(`-d, --dynamic-type <none>`, [オブジェクトの完全な動的型を表示]),
		(`-f, --format <fmt>`, [フォーマット]),
		(`-g, --show-globals`, [グローバル変数を表示]),
		(`-l, --no-locals`, [局所変数を省略]),
		(`-r, --regex`, [変数名を正規表現として解釈]),
		(`-s, --scope`, [変数のスコープを表示]),
		(`-t, --no-recognized-args`, [recognized function argumentsを省略]),
		(`-y, --summary <name>`, [変数の出力が使用すべきサマリーを指定]),
		(`-z, --summary-string <name>`, [フォーマットに使用するサマリー文]),
	)
	== ディスプレイの代用
		LLDBには`display`の直接的なコマンドはありません(エイリアスとしては存在します)。
		代わりに`target stop-hook`コマンドを使用して、停止時に実行するコマンドを設定できます。
		`target stop-hook`で`frame variable`を追加することで`display`と同様の動作を行えます。
		#lldb("target stop-hook add --one-liner \"frame variable argc argv\"")
