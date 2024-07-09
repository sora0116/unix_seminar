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

#let ops(cons) = [
  `options`に指定できるオプションは以下の通りです:
  #let t = cons.flatten()
  #table(
    columns: (1fr, 1fr),
    align: (x,y) => if y==0 {center} else {left},
    [option name], [description],
    ..t
  )
]
#let ops3(cons) = [
  `options`に指定できるオプションは以下の通りです:
  #let t = cons.flatten()
  #table(
    columns: (1fr, 1fr, 1fr),
    align: (x,y) => if y==0 {center} else {left},
    [option name], [description], [],
    ..t
  )
]
#let op_line = (`-l, --line <linenum>`, [行数を指定])
#let op_file = (`-f, --file <filename>`, [ファイル名を指定])
#let op_dummy-breakpoints = (`-D, --dummy-breakpoints`, [ダミーブレークポイントを指定])
#let op_one-liner = (`-o, --one-liner <cmd>`, [停止時に実行するコマンドを設定])
#let op_python-function = ([`-F, --python-function <func>`], [停止時に実行するPythonの関数を設定])
#let op_script-type = (`-s, --script-type <none>`, [コマンドの言語を指定。`command, python, lua, default-script`が指定可能])
#let op_stop-on-error = (`-e, --stop-on-error <bool>`, [コマンド実行時エラーで停止するかの設定])
#let op_structured-data-key = (`-k, --structured-data-key <none>`, [The key for a key/value pair passed to the implementation of a breakpoint command.  Pairs can be specified more than once.])
#let op_structured-data-value = (`-v, --structured-data-value <none>`, [The value for the previous key in the pair passed to the implementation of a breakpoint command.  Pairs can be specified more than once.])
#let op_ignore-count = (`-i, --ignore-count <count>`, [ignore-counterを設定します])
#let op_disabled = (`-d, --disabled`,[現在無効な(リストで指定した以外の)すべてを指定])
#let op_force = (`-f, --force`,[警告なしですべて指定])
#let op_brief = (`-b, --brief`,[情報を短く表示])
#let op_full = (`-f, --full`,[すべての情報を表示])
#let op_internal = (`-i, --internal`,[デバッガの内部ブレークポイントも表示])
#let op_verbose = (`-v, --verbose`,[わかることすべてを表示])

#let gram(cmd) = [

  文法:
  #raw("  (lldb) " + cmd, block: true, lang: "shell")
]

= LLDB
  == コマンド構文
    GDBの自由な形式のコマンドとは異なり、LLDBは構造化されたコマンドを持ちます。すべてのLLDBコマンドは以下の形をしています。

    ```shell
      <noun> <verb> [-<options> [<option-value>]] [<argument> [<argument>...]]
    ```
    - `argument`, `options`, `option-value`は全てホワイトスペースで区切られます。
    - スペースを含む引数はシングルまたはダブルクォートで囲むことで保護できます。
    - 引数内の"及び\\は\\でエスケープできます。
    - バッククォートで囲んだ文字列は式として解釈され値に置き換わります。
    - `--`を使用してそれ以前の引数のみをオプションとして明示できます。
    - TABによる補完が可能です。
    - `help`コマンドがあります。
    - `apropos`もあります。
    - エイリアスもあります。
    ```shell
      (lldb) command alias bfl breakpoint set -f %1 -l %2
    ```
    - 規定のエイリアスもあります。網羅的ではないです。
    - `~/.ldinit`にエイリアスを書けば一般に使用できる。helpにも反映される。
    - GDBコマンドのエイリアスも結構ある。
    - `unalias`もできる。
    - `script`でPythonインタプリタにアクセスできる。
  == プログラムをLLDBに読み込む
    先ず、デバッグするプログラムを指定します。LLDB起動時に、コマンドラインでデバッグするプログラムを指定できます。
    ```shell
      $ lldb <program>
    ```
    若しくはLLDB起動後に`file`コマンドで指定します。
    ```shell
      (lldb) file <program>
    ```
  == ブレークポイントを管理する
    `help breakpoint [<subcommand>]`でブレークポイント関連のコマンドのヘルプを閲覧できます。
    === clear
      指定したファイル、行数にあるブレークポイントを削除または無効化します。
      #gram("breakpoint clear <options>")
      #ops((op_line, op_file))
    === command
      停止時のコマンドを設定します。
      #gram("breakpoint command <subcommand> [<subcommand-options>] <breakpt-id>")
      `subcommand`には`add, delete, list`が指定できます。
      ==== add
        コマンドを追加します。
        #gram("breakpoint command add <options> [<breakpoint-id>]")
        #ops((
          op_dummy-breakpoints,
          op_one-liner,
          op_python-function,
          op_script-type,
          op_stop-on-error,
          op_structured-data-key,
          op_structured-data-value,
        ))
      ==== delete
        コマンドを削除します。
        #gram("breakpoint delete <options> [<breakpoint-id-list>]")
        #ops((
          op_dummy-breakpoints,
          op_disabled,
          op_force
        ))
      ==== list
        設定されているブレークポイントを表示します。
        #gram("breakpoint list <options> [<breakpoint-id>]")
        #ops3((
          op_dummy-breakpoints, [],
          op_brief,
          table.cell(rowspan: 4)[`bi`, `fi`, `iv`の組み合わせのみ可],
          op_full,
          op_internal,
          op_verbose,
        ))
      === delete
        ブレークポイントを削除します。
        #gram("breakpoint delete <options> [<breakpoint-id-list>]")
        #ops3((
          op_dummy-breakpoints,
          table.cell(rowspan: 3)[短縮して指定可能`-Ddf`],
          op_disabled,
          op_force,
        ))
    === disable
      ブレークポイントを無効化します。
      #gram("breakpoint disable [<breakpoint-id-list>]")
    === enable
      ブレークポイントを有効化します。
      #gram("breakpoint enable [<breakpoint-id-list>]")
    === list
      設定されているブレークポイントを表示します。

      文法:
      ```shell
        (lldb) breakpoint list [<options>] [<breakpoint-id>]
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr, .3fr), 
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],[],
        [`-D, --dummy-breakpoints`],[ダミーブレークポイントを表示],[],
        
        [`-b, --brief`],[ブレークポイントの情報を短く表示],
        table.cell(rowspan: 4)[`bi`, `fi`, `iv`の組み合わせのみ可],
        [`-f, --full`],[ブレークポイントのすべての情報を表示],
        [`-i, --internal`],[デバッガの内部ブレークポイントも表示],
        [`-v, --verbose`],[ブレークポイントについてわかることすべてを表示],
      )
    === modify
      設定されているブレークポイントの内容を変更します。

      文法:
      ```shell
        (lldb) breakpoint modify [<options>] [<breakpoint-id-list>]
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr, .3fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],[],
        [`-D, --dummy-breakpoints`], [ダミーブレークポイント],
        table.cell(rowspan: 3)[まとめて`-De`のように指定可能],
        [`-d, --disable`], [ブレークポイントを無効化],
        [`-e, --enable`],[ブレークポイントを有効化],

        [`-G --auto-continue <bool>`], [コマンド実行後自動で再開],
        table.cell(rowspan: 8)[],
        [`-c, --condition <cond>`], [条件式`cond`を満たすときだけ停止],
        [`-i, --ignore-count <n>`], [ブレークポイントを無視する回数],
        [`-o, --one-shot <bool>`], [一度停止したら削除],
        [`-q, --queue-name <name>`], [指定したキューに入っているスレッドのみ停止],
        [`-t, --thread-id <tid>`], [指定したスレッドのみ停止],
        [`-x, --thread-index <tidx>`], [指定したインデクスのスレッドのみ停止],
        [`-T, --thread-name <name>`], [指定したスレッドのみ停止],
      )
    === name
      ブレークポイントの名前を管理します。

      文法:
      ```shell
        (lldb) breakpoint name <subcommand> [<options>]
      ```
      `subcommand`には`add, configure, delete, list`が指定できます。
      ==== add
        名前を追加します。

        文法:
        ```shell
          (lldb) breakpoint name add <options> <breakpoint-id-list>
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => if y==0 {center} else {left},
          [option name], [description],
          [`-N, --name <breakpoint-name>`], [追加する名前],
        )
      ==== configure
        名前のあるブレークポイントを編集します。ブレークポイントIDを指定した場合、オプションをコピーします。それ以外ではそのまま編集されます。

        文法:
        ```shell
          (lldb) breakpoint name configure [<options>] [<breakpoint-name-list>]
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => if y==0 {center} else {left},
          [option name], [description],
          [`-d, --disable`], [無効化されたブレークポイントを設置],
          [`-e, --enable`],[ブレークポイントを有効化],
          [`-G --auto-continue <bool>`], [コマンド実行後自動で再開],
          [`-C, --command <cmd>`], [停止時に自動実行するコマンド],
          [`-c, --condition <cond>`], [条件式`cond`を満たすときだけ停止],
          [`-i, --ignore-count <n>`], [ブレークポイントを無視する回数],
          [`-o, --one-shot <bool>`], [一度停止したら削除],
          [`-q, --queue-name <name>`], [指定したキューに入っているスレッドのみ停止],
          [`-t, --thread-id <tid>`], [指定したスレッドのみ停止],
          [`-x, --thread-index <tidx>`], [指定したインデクスのスレッドのみ停止],
          [`-T, --thread-name <name>`], [指定したスレッドのみ停止],
          [`-D, --allow-delete <bool>`], [名前で削除、すべて削除を許可],
          [`-A, --allow-disable <bool>`], [名前で無効化、すべて無効化を許可],
          [`-L, --allow-list <bool>`], [明示的に指定されないリストを許可],
          [`-B, --breakpoint-id <breakpoint-id>`], [ブレークポイントIDを指定],
          [`-H, --help-string <none>`], [名前の目的の説明を設定],
        )
      ==== delete
        名前を削除します。

        文法:
        ```shell
          (lldb) breakpoint name delete <options> <breakpoint-id-list>
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => if y==0 {center} else {left},
          [option name], [description],
          [`-N --name <name>`], [削除する名前を指定],
        )
      ==== list
        名前を表示します。

        文法:
        ```shell
          (lldb) breakpoint name list <options>
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => if y==0 {center} else {left},
          [option name], [description],
          [`-D, --dummy-breakpoints`], [ダミーブレークポイントを表示],
        )
    === read
      以前に`write`で保存したブレークポイントを読み込みます。

      文法:
      ```shell
        (lldb) breakpoint read <options>
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],
        [`-f, --file <filename>`], [読み込むファイルを指定],
        [`-N, --breakpoint-name <name>`], [指定した名前のブレークポイントのみ読み込む],
      )
    === set
      プログラムにブレークポイントを設置します。

      文法:
      ```shell
        (lldb) breakpoint set <options>
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr, .3fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],[],
        [`-A, --all-files`], [全てのファイルを検索],
        table.cell(rowspan: 4)[フラグ。\ まとめて`-ADHd`のように指定可能],
        [`-D, --dummy-breakpoints`], [ダミーのブレークポイントを設置],
        [`-H, --hardware`], [ハードウェアブレークポイントを使用],
        [`-d, --disable`], [無効化されたブレークポイントを設置],

        [`-l, --line <linenum>`], [行番号`linenum`を指定],
        table.cell(rowspan: 11)[場所指定。併用不可],
        [`-a, --address <addr>`], [アドレス`addr`を指定],
        [`-n, --name <func>`], [関数名`func`を指定],
        [`-F, --fullname <name>`], [関数の完全修飾名を指定],
        [`-S, --selector <selector>`], [Objective-Cのセレクタ名を指定],
        [`-M, --method <method>`], [C++のメソッド名を指定],
        [`-r, --func-regex <reg>`], [正規表現`reg`にマッチする関数名を持つ関数を指定],
        [`-b, --basename <func>`], [関数の基本名が`func`の関数を指定(C++の名前空間や引数を無視)],
        [`-p, --source-pattern-regex <reg>`], [指定したファイル内のソースコードで正規表現にマッチする箇所を指定],
        [`-E, --language-exceprion <lang>`], [指定した言語の例外スローを指定],
        [`-y, --joint-specifier <linespec>`], [`filename:line[:column]`の形式でファイルと行を指定],
        
        [`-k, --structured-data-key <none>`], [スクリプトによるブレークポイントの実装に渡されるキーと値のペアのキー。 ペアは複数指定できます。],
        table.cell(rowspan: 18)[その他のオプション。\ 併用できないものもある],
        [`-v, --structured-data-value <none>`], [スクリプトによるブレークポイントの実装に渡されるキーと値のペアの値。 ペアは複数指定できます。],
        [`-G --auto-continue <bool>`], [コマンド実行後自動で再開],
        [`-C, --command <cmd>`], [停止時に自動実行するコマンド],
        [`-c, --condition <cond>`], [条件式`cond`を満たすときだけ停止],
        [`-i, --ignore-count <n>`], [ブレークポイントを無視する回数],
        [`-o, --one-shot <bool>`], [一度停止したら削除],
        [`-q, --queue-name <name>`], [指定したキューに入っているスレッドのみ停止],
        [`-t, --thread-id <tid>`], [指定したスレッドのみ停止],
        [`-x, --thread-index <tidx>`], [指定したインデクスのスレッドのみ停止],
        [`-T, --thread-name <name>`], [指定したスレッドのみ停止],
        [`-R, --address-slide <addr>`], [指定されたオフセットを、ブレークポイントが解決するアドレスに追加します。現在のところ、これは指定されたオフセットをそのまま適用し、命令境界に整列させようとはしません。],
        [`-N, --breakpoint-name <name>`], [ブレークポイントの名前],
        [`-u, --column <col>`], [列を指定],
        [`-f, --file <filename>`], [検索するファイルを指定],
        [`-m, --move-to-nearest-code <bool>`], [一番近いコードへブレークポイントを移動],
        [`-s, --shlib <name>`], [共有ライブラリを指定],
        [`-K, --skip-prologue <bool>`], [プロローグをスキップ],
      )
    === write
      ブレークポイントをファイルに保存します。`read`で読み込めます。ブレークポイントを指定しなければ全て保存されます。

      文法:
      ```shell
        (lldb) breakpoint write <options> [<breakpoint-id-list>]
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],
        [`-a, --append`], [ファイルが既存ならば追加],
        [`-f, --file <filename>`], [保存先のファイル名],
      )
  == ウォッチポイントを管理する
    `help watchpoint [<subcommand>]`でウォッチポイント関連のコマンドのヘルプを閲覧できます。
    === command
      ウォッチポイントにヒットしたときに実行するコマンドを管理します。

      文法:
      ```shell
        (lldb) watchpoint command <subcommand> [<options>]
      ```
      `subcommand`には`add, delete, list`が指定できます。
      ==== add
        コマンドを追加します。

        文法:
        ```shell
          (lldb) watchpoint command add [<options>] <watchpoint-id>
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => if y==0 {center} else {left},
          [option name], [description],
          [`-o, --one-liner <cmd>`], [停止時に実行するコマンドを設定],
          [`-F, --python-function <func>`], [停止時に実行するPythonの関数を設定],
          [`-s, --script-type <none>`], [コマンドの言語を指定。`command, python, lua, default-script`が指定可能],
          [`-e, --stop-on-error <bool>`], [コマンド実行時エラーで停止するかの設定],
        )
      ==== delete
        コマンドを削除します。

        文法:
        ```shell
          (lldb) watchpoint command delete <watchpoint-id>
        ```
      ==== list
        コマンドを表示します。

        文法:
        ```shell
          (lldb) watchpoint command list <watchpoint-id>
        ```
    === delete
      ウォッチポイントを削除します。

      文法:
      ```shell
        (lldb) watchpoint delete [<options>] [<watchpoint-id-list>]
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],
        [`-f, --force`], [確認なしで削除],
      )
    === disable
      ウォッチポイントを無効化します。

      文法:
      ```shell
        (lldb) watchpoint disable [<watchpoint-id-list>]
      ```
    === enable
      ウォッチポイントを有効化します。

      文法:
      ```shell
        (lldb) watchpoint enable [<watchpoint-id-list>]
      ```
    === ignore
      イグノアカウンタを設定します。

      文法:
      ```shell
        (lldb) watchpoint ignore <options> <watchpoint-id-list>
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],
        [`-i, --ignore-count`], [ウォッチポイントを無視する回数],
      )
    === list
      設定されたウォッチポイントを表示します。

      文法:
      ```shell
        (lldb) watchpoint list [<options>] [<watchpoint-id-list>]
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr, .3fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],[],
        [`-b, --brief`], [短い説明を表示],
        table.cell(rowspan: 3)[オプションは併用不可],
        [`-f, --full`], [完全な説明を表示],
        [`-v, --verbose`], [全てを表示],
      )
    === modify
      ウォッチポイントを変更します。

      文法:
      ```shell
        (lldb) watchpoint modify [<options>] [<watchpoint-id-list>]
      ```
      `options`に指定できるオプションは以下の通りです:
      #table(columns: (1fr, 1fr),
        align: (x, y) => {if y == 0 {center} else {left}},
        [option name], [description],
        [`-c, --condition <cond>`], [条件を満たすときだけ停止],
      )
    === set
      ウォッチポイントを設定します。

      文法:
      ```shell
        (lldb) watchpoint set <subcommand> [<options>]
      ```
      `subcommand`には`expression, variable`が設定できます。
      ==== expression
        式の結果が指すアドレスにウォッチポイントを設定します。

        文法:
        ```shell
          (lldb) watchpoint set expression [<options>] -- <expr>
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => {if y == 0 {center} else {left}},
          [option name], [description],
          [`-w, --watch <type>`], [ウォッチのタイプを指定。`read, write, read_write`が指定可能],
          [`-s, --size <size>`], [監視するバイト数],
        )
      ==== variable
        変数にウォッチポイントを設定します。

        文法:
        ```shell
          (lldb) watchpoint set variable [<options>] -- <varname>
        ```
        `options`に指定できるオプションは以下の通りです:
        #table(columns: (1fr, 1fr),
          align: (x, y) => {if y == 0 {center} else {left}},
          [option name], [description],
          [`-w, --watch <type>`], [ウォッチのタイプを指定。`read, write, read_write`が指定可能],
          [`-s, --size <size>`], [監視するバイト数],
        )
  == プロセスを制御する
    LLDBでプログラムを開始するには`process`コマンドを使用します。
    #gram("process <subcommand> [<options>]")
    `subcommand`には`attach, connect, continue, detach, handle, interrupt, kill, launch, load, plugin, save-core, signal, status, trace, unload`が指定できます。
    === attach
      プロセスにLLDBをアタッチします。
      #gram("process attach <options>")
      #let op_continue = (`-c, --continue`, [アタッチ後に停止せずに継続])
      #let op_include-existing = (`-i, --include-existing`, [`-w`指定時に、すでに存在するプロセスを含む])
      #let op_waitfor = (`-w, --waitfor`, [`-n`で指定した名前のプロセスが起動するまで待つ])
      #let op_pid = (`-p, --pid`, [プロセスIDを指定])
      #let op_name = (`-n, --name`, [名前を指定してアタッチ])
      #let op_plugin = (`-P, --plugin <plugin>`, [プロセスプラグインを指定])
      #ops((
        op_continue,
        op_include-existing,
        op_waitfor,
        op_pid,
        op_name,
        op_plugin,
      ))
    === connect
      リモートデバッグサービスに接続します。#todo("確認")
      #gram("process connect <remote-url>")
    === continue
      現在のプロセスのすべてのスレッドを継続実行します。
      #gram("process continue <options>")
      #ops(op_ignore-count)
    === detach
      プロセスからデタッチします。
      #gram("process detach <options>")
      #ops((
        (`-s, --keep-stopped <bool>`, [])
      ))
    === handle
    === interrupt
    === kill
    === launch
    === load
    === plugin
    === save-core
    === signal
    === status
    === trace
    === unload
  == プログラムを制御する
// EOF
