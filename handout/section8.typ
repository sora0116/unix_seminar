= スタックの検証
== スタックフレーム
コールスタックはスタックフレームに分割され、各フレームは関数呼び出しに関するデータを保持します。

GDBは既存のスタックフレームにそれぞれレベルをつけます。レベルは最も内側のフレームが0、それを呼んだフレームが1...という風に付きます。

== バックトレース
プログラムの呼び出し履歴をバックトレースと云います。
`
	backtrace [option]... [qualifier]... [count]
	bt [option]... [qualifier]... [count]
`
すべてのスタックフレームのバックトレースを表示します。`count`は正の値を指定すると内側いくつか、負の値では外側いくつかを表示します。
optionに指定できるものは以下のとおりです。
- `-full`: ローカル変数の値も表示する。
- `-no-filters`: Pythonフレームフィルタを実行しません。
- `-hide`: Python フレームフィルタでelideにされたフレームを表示しません。
- `-past-main [on|off]`: main以降もバックトレースを続けるかどうか。`backtrace past-main`で設定可。
- `-past-entry [on|off]`: エントリポイント移行もバックトレースを続けるかどうか。`backtrace past-entry`で設定可。
- `-entry-values 'no|only|preferred|if-needed|both|compact|default'`: 関数入力時のprintの設定。`print entry-values`で設定可。
- `-frame-arguments all|scalars|none`: 非スカラーフレーム引数のprintの設定。`print frame-arguments`で設定可。
- `-raw-frame-arguments [on|off]`: フレーム引数を生で表示するかどうか。`print raw-frame-arguments`で設定可。
- `-frame-info auto|source-line|location|source-and-location|location-and-address|short-location`: フレーム情報のprint設定。`print framw-info`で設定可。
qualifierは下位互換のための引数です。

マルチスレッド環境では、現在のスレッドのバックトレースが表示されます。複数のスレッドのバックトレースを表示するには`thread apply`を使用できます。

== フレームの選択
`
	frame [frame-selection-spec]
	f [frame-selection-spec]
`
指定したフレームを選択します。指定子に指定できるものは以下です。
- `<num>, level <num>`: スタックフレームレベル。
- `address <stack-address>`: スタックアドレス。`info frame`で確認できます。
- `function <function-name>`: 関数名でスタックを指定します。
- `view <stack-address> [pc-addr]`: GDBのバックトレースの一部ではないフレームを表示する。
`
	up [n]
	down [n]
`
現在選択中のフレームの`n`個上(外側)、下(内側)のフレームを選択します。

== フレーム情報
`
	info frame [frame-selection-spec]
	info f [frame-selection-spec]
`
フレーム情報を表示します。
`
	info args [-q] [-t <type_regexp>] [regexp]
`
選択されたフレームの引数を表示します。`-q`を指定するとヘッダー情報や引数が出力されなかった理由を説明するメッセージが非表示になります。
後ろ2つのオプションは引数の型または名前を指定できます。
`
	info locals [-q] [-t <type_regexp>] [regexp]
`
選択されたフレームのローカル変数を表示します。オプションは`info args`と同じです。

== それぞれのフレームにコマンドを適用する
`
	frame apply [all|count|-count|level <level>...] [option]... <command>
`
指定したフレームにコマンドを適用します。
optionに指定できるものは以下のとおりです。
- `-past-main`: mainより先もバックトレースを続けます。
- `-past-entry`: エントリポイント以降もバックトレースを続けます。
- `-c`: エラーがあったときに表示して、継続します。
- `-s`: エラーがあったときに表示せずに、継続します。
- `-q`: フレーム情報を表示しません。
`
	faas <comamnd>
`
`frame applu all -s <command>`のエイリアス。
