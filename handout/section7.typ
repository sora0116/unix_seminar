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
最大のレコード容量を設定できます。デフォルトでは200000です。レコードが最大容量に達すると、一番最初の命令から順番に削除しながらレコードが進みます。`limit`に0または`unlimited`が設定された場合、命令は削除されません。
`
	set record full stop-at-limit 'on|off'
`
レコードが最大容量に達したときに停止して続行するかどうかを尋ねます。
`
	set record full memory-query 'on|off'
`
GDBが`full`のレコードをするとき、命令によって引き起こされたメモリ変更を記録できない場合の動作を制御します。onの場合にはどうするかを尋ね、offの場合には無視します。
`
	set record btrace replay-memory-access 'read-only|read-write'
`
リプレイ中にメモリにアクセスする際のbtraceレコードメソッドの動作を制御します。`read-only`の場合、GDBはreadonlyメモリへのアクセスのみを許可します。`read-write`の場合、GDBはreadonlyおよびreadwriteメモリへのアクセスを許可します。
`
	set record btrace cpu <identifier>
`
プロセッサ・エラッタを回避するために使用するプロセッサを設定します。プロセッサ・エラッタとは、設計や製造に起因するプロセッサ動作の血管のことを指します。

引数の`identifier`はCPU識別子で`vendor:processor identifier`という形か`none, auto`が指定できます。
`
	set record btrace bts buffer-size <size>|'unlimited'
`
BTS形式でのブランチトレースに要求されるリングバッファのサイズを指定します。デフォルト値は64KBです。
`
	set record btrace pt buffer-size <size>|'unlimited'
`
IPTでのリングバッファのサイズを設定します。デフォルト値は16KBです。
`
	info record
`
レコード方式によってさまざまな統計情報を表示します。
`
	record delete
`
レコード大賞が過去で実行された場合、それ以降のログを削除し、現在のアドレスからレコードを再開します。
`
	record instruction-history
`
レコードされたログから命令を逆アセンブルします。
`
	set record instruction-history-size <size>|'unlimited'
`
`record instruction-history`で表示される命令の数を設定します。
`
	record function-call-history
`
関数単位で実行履歴を表示します。
`
	set record function-call-history-size <size>|'unlimited'
`
`record function-call-history`で表示される数を設定します。
