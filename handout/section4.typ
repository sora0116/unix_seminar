= GDBでプログラムを実行する
GDBでプログラムを実行するにはコンパイル時にデバッグ情報を付与する必要があります。

任意の環境で、引数を指定してGDBを起動できます。ネイティブデバッグではプログラムのIOをリダイレクトしたり、実行中プロセスをデバッグしたり、子プロセスを強制終了したりできます。

== デバッグのためのコンパイル
プログラムを効果的にデバッグするにはコンパイル時にデバッグ情報を生成する必要があります。この情報はオブジェクトファイルに保存され、各変数、関数のデータ型と実行可能コード内のソース行番号とアドレスの対応関係が記述されます。

デバッグ情報の生成は`-g`オプションで行うことができます。

GCCでは`-g`オプションは`-O`(最適化オプション)と併用できます。

== プログラムの開始
/ `run, r`: 
GDBでプログラムを実行するには`run`コマンドを使用します。このコマンドを使用するにはGDB起動時またはコマンドでプログラムを指定する必要があります。

/ 引数:
`run`コマンドの引数はそのままプログラムのコマンドライン引数として渡されます。

/ 環境:
プログラムはGDBから環境を継承します。`set`コマンドで環境を変更することもできます。

/ 作業ディレクトリ:
`set cwd`でプログラムの作業ディレクトリを設定できます。設定しない場合、GDBの作業ディレクトリを引き継ぎます。リモートデバッグの場合にはリモートサーバの作業ディレクトリを引き継ぎます。

/ 標準入出力:
通常、プログラムの標準入出力はGDBと同じになります。`tty`コマンドで別のデバイスを設定することもできます。

`run`コマンドで実行したプログラムは直ちに実行を開始します。

GDBはシンボルファイルの変更を検出し、再読み込みを行います。

`
	start
`
`start`コマンドはメインプロシージャにブレークポイントを設置して`run`します。引数の扱いは`run`と同様です。
`
	starti
`
`start`と同様ですが、ブレークポイントの位置は最初の命令です。
`
	set exec-wrapper <wrapper>
	show exec-wrapper
	unset exec-wrapper
`
<wrapper>を使用してデバッグ用プログラムの起動します。つまりShellコマンド`exec wrapper program`を実行します。

`
	set startip-with-shell
	set startip-with-shell on
	set startip-with-shell off
	show startip-with-shell
`
プログラムをシェルで実行します。
`
  set auto-connect-native-target
  set auto-connect-native-target on
  set auto-connect-native-target off
  show auto-connect-native-target
`
現在の下位プロセスがターゲットに接続されていないときにローカルマシンで実行します。
`
  set disable-randomization
  set disable-randomization on
`
プログラムの仮想アドレス空間のネイティブランダム化をオフにします。

== プログラムの引数
プログラムへの引数は`run`コマンド実行時に指定します。指定しなかった場合は以前の`run`実行時の引数または`set args`で指定した引数を使用します。
`
	set args
	show args
`

== プログラムの環境
環境は、環境変数とその値のことを指します。
`
	path <directory>
`
環境変数の先頭にディレクトリを追加します。GDBが使用する環境変数の値は変化しません。
`
	show paths
`
実行可能ファイルの検索パスのリストを表示します。
`
	show environment [varname]
`
環境変数`varname`の値を表示します。指定しない場合はすべての環境変数とその値を表示します。
`
	set environment varname [=value]
`
環境変数`varname`の値を設定します。値はプログラムに対してのみ変更され、GDBが読む変数の値は変わりません。

== プログラムの作業ディレクトリ
`
	set cwd [directory]
`
下位の作業ディレクトリを`directory`に変更します。
`
	show cwd
`
下位プロセスの作業ディレクトリを表示します。
`
	cd
`
GDBの作業ディレクトリを変更します。
`
	pwd
`
GDBの作業ディレクトリを表示します。

== プログラムの入出力
デフォルトではGDBが実行するプログラムはGDBと同じターミナルに入出力を行います。
`
	info terminal
`
プログラムが使用している端末モードについての情報を表示します。

	`run`コマンドでシェルのリダイレクト機能を使えます。
`
	run > <output file>
`
`tty`コマンドで入出力の場所を指定できます。
`
	tty <file>
`
`
	set inferior-tty <tty>
	show inferior-tty
`
デバッグ対象のプログラムのttyを設定、表示します。

== すでに実行中のプロセスのデバッグ
`
	attach <pid>
`
すでに実行中のプロセスのプロセスIDを指定してデバッガをアタッチします。
`
	set exec-file-mismatch 'ask|warn|off'
	show exec-file-mismatch
`
GDBがロードした実行ファイルとアタッチしたプログラムの実行ファイルが一致するか確認した際に不一致だった場合の挙動を設定します。
askは警告を出しプロセスの実行ファイルをロードするか確認します。warnは警告を表示のみします。offは不一致確認を行いません。

GDBはプロセスにアタッチするとそのプロセスを停止します。続行するには`continue`をします。
`
	detach
`
プロセスからデタッチします。

== 子プロセスの終了
`
	kill
`
GDBで実行されている子プロセスを終了します。

== 複数の下位接続とプログラムのデバッグ
GDBでは1セッションで複数のプログラムを実行、デバッグできます。一部システムでは同時に行えます。

GDBでは各プログラムの状態をinferiorと呼ばれるオブジェクトで管理します。
`
	info inferior
`
現在存在するinferiorを表示します。
`
	inferior
`
現在のinferiorの情報を表示します。
`
	info connection
`
現在開いているターゲット接続を表示します。
`
	inferior <infno>
`
現在のinferiorをinfnoに変更します。
`
	add-inferior [-copies <n>] [-exec <executable>] [-no-connection]
`
実行ファイルを`executable`とするinferiorをn個追加します。
`
	clone-inferior [-copies <n>] [infno]
`
inferiorをn個コピーします。
`
	remove-inferiors infno...
`
inferiorを削除します。
`
	detach inferior infno...
	kill inferior infno...
`
inferiorを指定してdetach, killします。
`
	set print inferior-events [on|off]
	show print inferior-events
	
`
inferiorのプロセスが開始または終了したときに通知を受け取ります。
`
	maint info program-spaces
`
GDBによって管理されているすべてのプログラムスペースのリストを出力します。

=== inferior固有のブレークポイント
複数のinferiorプロセスをデバッグする場合、すべてのinferiorプロセスにブレークポイントを設定するか、個別にするか選択できます。
`
	break <locspace> inferior inferior-id
	break <locspace> inferior inferior-id if ...
`

== 複数スレッドのプログラムのデバッグ
GDBはマルチスレッドデバッグを行うために以下の機能を提供します。
- 新しいスレッドの自動通知
- スレッドを切り替えるコマンド
- 既存のスレッドの情報を表示するコマンド
- スレッドのリストにコマンドを適用するコマンド
- スレッド固有のブレークポイント
- スレッド開始、終了時のメッセージ設定
GDBでは複数スレッドを観察できます。今見えているスレッドをカレントスレッドといいます。デバッグコマンドはカレントスレッドに適応されます。

新しいスレッドを検出するとスレッド識別子を表示します。

`
	info threads [-gid] [thread-id-list]
`
スレッドの情報を表示します。引数を指定しなければすべてのスレッドの情報が表示されます。`-gid`を指定するとグローバルスレッド番号も表示します。
`
	thread <tid>
`
カレントスレッドを`tid`のスレッドに変更します。
`
	thread apply [thread-id-list | all [-ascending]] [flag]... <command>
`
指定したスライド全体にコマンドを適用します。フラグに設定できるのは以下のとおりです。
/ `-c`: コマンド内のエラーを表示してその後のコマンドは続行されます。
/ `-s`: コマンド内のエラーを無視します。
/ `-q`: スレッド情報を表示しません。
`
	taas [option]... <command>
`
`thread apply all -s [option]... <command>`のショートカット。
`
	tfaas [option]... <command>
`
`thread apply all -s -- frame apply all -s [option]... <command>`のショートカット。
`
	thread name [name]
`
カレントスレッドに名前をつけます。名前を指定しない場合は名前を削除します。
`
	thread find [regexp]
`
指定した正規表現と一致する名前またはシステムタグを持つスレッドを検索して表示します。
`
	set print thread-event [on|off]
	show print thread-event
`
スレッド開始、終了時のメッセージを有効または無効にします。

== フォークのデバッグ
`
	set follow-fork-mode <mode>
`
forkの呼び出しに対する応答を設定します。
- `parent`
	元のプロセスはforkのあとデバッグされます。子プロセスは妨げられずに実行されます。デフォルト。
- `child`
	新しいプロセスがforkのあとにデバッグされます。親プロセスは妨げられずに実行されます。
`
	set detach-on-fork 'on|off'
`
- `on`
	子プロセスは切り離され、独立して実行されます。(デフォルト)
- `off`
	両方のプロセスがGDBの制御化に置かれます。片方のプロセスは中断されます。(別inferior)

== チェックポイント、再起動
デバッグ中の状態にチェックポイントをおいて戻ることができます。
`
	checkpoint
`
現在の状態にチェックポイントを起きます。
`
	info checkpoint
`
設置されたチェックポイントの一覧を表示します。
`
	restart <checkpoint-id>
`
チェックポイントに戻ります。
`
	delete checkpoint <checkpoint-id>
`
チェックポイントを削除します。
