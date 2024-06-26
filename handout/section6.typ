= 後ろ向きのプログラム実行
サポートされている環境であれば、プログラムの実行を元に戻すことができます。
`
	reverse-continue [ignore-count]
	rc [ignore-count]
`
逆順に`continute`します。
`
	reverse-step [count]
`
逆順に`step`します。
`
	reverse-stepi [count]
`
逆順に`stepi`します。
`
	reverse-next [count]
`
逆順に`next`します。
`
	reverse-nexti
`
逆順に`nexti`します。
`
	reverse-finish
`
現在の関数の呼び出しポイントまで戻ります。
`
	set exec-direction 'reverse|forward'
`
ターゲットの実行向きを指定します。
