#set page(numbering: "1")
#set heading(numbering: "1.1")
#set text(size: 12pt, font: ("New Computer Modern", "Harano Aji Mincho"))

#outline(title: "目次")

#include "section1.typ"
#include "section2.typ"
#include "section3.typ"
#include "section4.typ"
#include "section5.typ"
#include "section6.typ"
= Inferiorの実行の記録と再生
いくつかのOSではレコードすることによって逆順の実行ができます。
`
	record <method>
`
メソッドを指定してレコードします。メソッドは以下のとおりです。
- `full`: GDBソフトウェアによる完全なレコードです。
- `trace <format>`: ハードウェア命令によるレコードです。Intelプロセッサでサポートされます。データはリングバッファに書き込まれるので限定的な巻き戻しのみ可能です。フォーマットは以下のとおりです。
	- `bts`: Branch Trace Store。
	- `pt`: Intel Processor Trace。実行トレースを圧縮して保存します。

recordコマンドを使うにはプログラムを実行しておく必要があります。

ノンストップモードまたは非同期実行モードでは`full`はサポートされません。

`
	record stop
`
レコードを停止します。ログはすべて削除され、Inferiorは終了するか最終状態のままになります。リプレイモード中にこれを発行するとその時点から通常のデバッグに復帰します。
`
	record goto 'begin|start|end'|<n>
`
指定した場所に戻ります。beginとstartは同じ場所です。nはn番目の命令です。
`
	record save <filename>
`
レコードを保存します。
`
	record restore <filename>
`
ファイル名から実行ログをリストアします。`save`で保存したものを読みます。
`
	set record full insn-number-max <limit>|'unlimited'
`
最大のレコード容量を設定できます。デフォルトでは200000です。

#include "section8.typ"
