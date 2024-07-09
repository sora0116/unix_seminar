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
    LLDBでプロセスを制御するには`process`コマンドを使用します。
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
      シグナルのLLDBでの扱いを設定します。
      #gram("process handle <options> [<signal>...]")
      #ops((
        (`-n, --notify <bool>`, [デバッガがシグナル受信をユーザに知らせるか]),
        (`-p, --pass <bool>`, [シグナルをプロセスに渡すか]),
        (`-s, --stop <bool>`, [シグナル受信時にプロセスを停止するか])
      ))
      `signal`を指定しない場合、すべてのシグナルに対して設定されます。
    === interrupt
      現在のターゲットプロセスに割り込みを行います。
      #gram("process interrupt")
    === kill
      現在のターゲットプロセスをkillします。
      #gram("process kill")
    === launch
      プログラムを起動します。
      #gram("process launch <options> [<args>]")
      #ops((
        (`-s, --stop-at-entry`, [エントリポイントで停止]),
        (`-t, --tty <none>`, [プロセスを開始するターミナル]),
        (`-n, --no-stdio`, [標準出力を行わない]),
        (`-a, --arch <arch>`, [曖昧なときにアーキテクチャを指定]),
        (`-A, --disable-aslr <bool>`, [アドレス空間のランダム化を行うか]),
        (`-E, --environment <none>`, [環境変数を`NAME=VALUE`の形で設定]),
        (`-P, --plugin <plugin>`, [プロセスプラグイン名]),
        (`-c, --shell <filename>`, [プロセスを走らせるシェル]),
        (`-e, --stderr <filename>`, [標準エラー出力]),
        (`-X, --shell-expand-args <bool>`, [プロセス起動時にシェルが引数を拡張するか]),
        (`-i, --stdin <filename>`, [標準入力]),
        (`-o, --stdout <filename>`, [標準出力]),
        (`-w, --working-dir <dir>`, [プロセスのワーキングディレクトリ]),
        (`-C, --script-class <python-class>`, [scripted classの管理クラス名]),
        (`-k, --structured-data-key <none>`, [The key for a key/value pair passed to the implementation of a scripted process.  Pairs can be specified more than once.]),
        (`-v, --structured-data-value <none>`, [The value for the previous key in the pair passed to the implementation of a scripted process.  Pairs can be specified more than once.]),
      ))
    === load
      現在のプロセスに共有ライブラリをロードします。
      #gram("process load <options> <filename>...")
      #ops(((`-i <path>, --install=<path>`, [ターゲットに共有ライブラリをインストール])))
    === plugin
      現在のターゲットプロセスプラグインにコマンドを渡します。
      #gram("process plugin <args>")
    === save-core
      現在のプロセス状態をコアファイルに保存します。
      #gram("process save-core <options> <filename>")
      #ops((
        (`-p <plugin>, --plugin-name=<plugin>`, [コアファイルを生成するためのプラグイン]),
        (`-s, --style <corefile-style>`, [コアファイルの保存形式。`full, modified-memory, stack`が指定可能])
      ))
    === signal
      UNIXのシグナルをプロセスに送信します。
      #gram("process signal <signal>")
    === status
      プロセスのステータスと停止位置を表示します。
      #gram("process status <options>")
      #ops((`-v, --verbose`, [拡張情報を含むすべてのプロセスステータスを表示]))
    === trace
      プロセスをトレースします。
      #gram("process trace <subcommand> [<options>]")
      `subcommand`には`save, start, stop`が指定できます。
      === save
        現在のプロセスのトレースを保存します。
        #gram("process trace save [<options>]")
        #ops((`-d, --directory <dir>`, [保存場所]))
      === start
        トレースを開始します。
        #gram("process trace start <options>")
      === stop
        トレースを終了します。
        #gram("process trace stop")
    === unload
      現在のプロセスから共有ライブラリをアンロードします。
      #gram("process unload <index>")
  == スレッドを制御する
    スレッドを制御するには`thread`コマンドを使用します。
    #gram("thread <subcommand> [<options>]")
    `subcommand`には`backtrace, continue, exception, info, jump, list, plan, return, select, siginfo, step-in, step-inst, step-inst-over, step-out, step-over, step-scripted, trace, until`が指定できます。
    === backtrace
      スレッドのコールスタックを表示します。
      #gram("thread backtrace <options>")
      #ops((
        (`-c, --count <count>`, [表示するフレームの数。-1は全て]),
        (`-e, --extended <bool>`, [拡張バックトレース]),
        (`-s, --start <frame-index>`, [バックトレースの開始フレーム]),
      ))
    === continue
      プロセスを継続実行します。スレッドを指定しない場合全てのスレッドが対象になります。
      #gram("thread continue <thread-index>...")
    === exception
      現在の例外オブジェクトを表示します。
      #gram("thread exception")
    === info
      一つ以上のスレッドの概要情報を表示します。スレッドを指定しない場合、現在のスレッドが対象です。
      #gram("thread info <options>")
      #ops((
        (`-j, --json`, [JSON形式で表示]),
        (`-s, --stop-info`, [JSON形式で停止情報を表示])
      ))
    === jump
      プログラムカウンタを変更します。
      #gram("thread jump <options>")
      #ops((
        (`-a, --address <expr>`, [ジャンプ先のアドレス]),
        (`-b, --by <offset>`, [ジャンプ先のオフセット]),
        (`-f, --file <filename>`, [ジャンプするファイル]),
        (`-l, --line <linenum>`, [ジャンプするソース行番号]),
        (`-r, --force`, [プログラムカウンタが関数の外に出ることを許可]),
      ))
    === list
      各スレッドについての概要を表示します。`setting set thread-format`で表示をカスタマイズできます。
      #gram("thread list")
    === plan
      スレッドの実行計画を管理するコマンドです。
      #gram("thread plan <subcommand> [<options>]")
      `subcommand`には`discard, list, prune`が指定できます。
      ==== discard
        スレッド計画を廃棄します。
        #gram("thread plan discard <index>")
      ==== list
        スレッド計画を表示します。
        #gram("thread plan list <options>")
        #ops((
          (`-i, --internal`, [内部スレッド計画も表示]),
          (`-t, --thread-id`, [スレッドIDを指定]),
          (`-u, --unreported`, [unreportedなスレッドを指定]),
          (`-v, --verbose`, [より多くの情報を表示])
        ))
      ==== prune
        現在のunreportedなスレッドのすべての計画を削除します。
        #gram("thread plan prune <thread-id>...")
    === return
      選択中のスタックフレームから返ります。
      #gram("thread return <options>")
      #todo("")
      #ops((
        (`-x, --from-expression`, [一番内側から式の値で返る]),
      ))
    === select
      選択中のスレッドを変更します。
      #gram("thread select <index>")
    === siginfo
      現在のsiginfoオブジェクトを表示します。
      #gram("thread siginfo")
    === step-in<step-in>
      ソースコード上のステップを行います。関数呼び出しの場合には関数の中に入ります。スレッドを指定しない限り現在のスレッドにのみ適用されます。
      #gram("thread step-in [<options>] [<thread-id>]")
      #ops((
        (`-A, --step-out-avoids-no-debug <bool>`, [ステップアウト時にデバッグ情報のある関数に当たるまでステップアウトを続ける]),
        (`-a, --step-in-avoids-no-debug <bool>`, [デバッグ情報のない関数にステップインせずにステップオーバーする]),
        (`-c, --count <count>`, [ステップ回数]),
        (`-e, --end-linenumber <linenum>`, [ステップを停止する行番号]),
        (`-m, --run-mode <mode>`, [他スレッドの処理方法。`this-thread, all-threads, while-stepping`が指定可能]),
        (`-r, --step-over-regexp <regex>`, [正規表現にマッチする関数をスキップ]),
        (`-t, --step-in-target <func-name>`, [直接呼び出された関数のステップイン時に停止する関数名]),
      ))
    === step-inst
      命令上のステップを行います。callは中に入ります。
      #gram("thread step-inst [<options>] [<thread-id>]")
      `options`に指定できるオプションは @step-in と同じです。
    === step-inst-over
      命令上のステップを行います。callはステップオーバーします。
      #gram("thread step-inst-over [<options>] [<thread-id>]")
      `options`に指定できるオプションは @step-in と同じです。
    === step-out
      現在のスタックフレームを抜けるまで実行し、停止します。
      #gram("thread step-out [<options>] [<thread-id>]")
      `options`に指定できるオプションは @step-in と同じです。
    === step-over
      ソースコード上のステップを行います。関数呼び出しはステップオーバーします。
      #gram("thread step-over [<options>] [<thread-id>]")
      `options`に指定できるオプションは @step-in と同じです。
    === step-scripted
      Step as instructed by the script class passed in the -C option.  You can also specify a dictionary of key (-k) and value (-v) pairs that will be used to populate an SBStructuredData Dictionary, which will be passed to the constructor of the class implementing the scripted step.  See the Python Reference for more details.
      #gram("thread step-scripted [<options>] [<thread-id>]")
      `options`には @step-in で指定できるものに加えて以下が指定可能です。
      #ops((
        (`-k, --structured-data-key`, [The key for a key/value pair passed to the implementation of a scripted step.  Pairs can be specified more than once.]),
        (`-v, --structured-data-value`, [The value for the previous key in the pair passed to the implementation of a scripted step.  Pairs can be specified more than once.]),
      ))
    === trace
      トレース関連のコマンドです。
      #gram("thread trace <subcommand> [<options>]")
      `subcommand`には`dump, export, start, stop`が指定可能です。
      ==== dump
        トレース情報を表示します。
        #gram("thread trace subcommand [<options>]")
        `subcommand`には`info, instructions`が指定できます。
        ===== info
          トレースされた情報をダンプします。
          #gram("thread trace info [<options>]")
          #ops(((`-v, --verbose`, [冗長なダンプ])))
        ===== instructions
          トレースされた命令をダンプします。
          #gram("thread trace instructions [<options>]")
          #ops((
            (`-c, --count <count>`, [表示する命令の数]),
            (`-f, --forwards`, [一番古い地点から表示]),
            (`-r, --raw`, [シンボル情報なし]),
            (`-s, --skip <index>`, [スキップする命令数]),
            (`-t, --tsc`, [可能なら命令ごとにタイムスタンプを表示]),
          ))
      ==== export
        トレースをエクスポートします。
        #gram("thread trace export <plugin> [<options>]")
      ==== start
        トレースを開始します。
        #gram("thread trace start [<options>]")
      ==== stop
        トレースを終了します。
        #gram("thread trace stop [<thread-index>...]")
    === until
      指定した箇所まで実行します。
      #gram("thread until <options> <linenum>")
      #ops((
        (`-a, --address <expr>`, [このアドレスに到達するか関数を抜けるまで実行]),
        (`-f, --frane <index>`, [対象のフレーム。デフォルトは0]),
        (`-m, --run-mode <mode>`, [実行モード。`this-thread, all-threads`]),
        (`-t, --thread <index>`, [対象のスレッド]),
      ))
  == フレームを制御する
    フレームを制御するには`frame`コマンドを使用します。
    #gram("frame <subcommand> [<options>]")
    `subcommand`には``が指定できます。
    === diagnose
      現在の停止位置がどのようなパスでレジスタやアドレスに到達したかを判断しようとします。
      #gram("frame diagnose [<options>] [<frame-index>]")
      #ops((
        (`-a, --address <addr>`, [アドレス]),
        (`-o, --offset <offset>`, [オフセット]),
        (`-r, --register <name>`, [レジスタ]),
      ))
    === info
      現在のフレームの情報を表示します。
      #gram("frame info")
    === select
      スタックフレームからフレームを選択します。
      #gram("frame select [<options>] [<frame-index>]")
      #ops((`-r, --relative <offset>`, [現在のフレームからのオフセットで指定]))
    === variable
      現在のスタックフレームに存在する変数を表示します。
      #gram("frame variable <options> [<varname>...]")
      #ops((
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
      ))
// EOF
// #outline(indent: 1em)
