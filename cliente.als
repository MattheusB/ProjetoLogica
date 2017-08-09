module loja

abstract sig Cliente{

}

sig Livro{

}

abstract sig  Drone{
	livrosComprados: set Livro
}

sig ClienteNormal extends Cliente{
		pedido: one DroneNormal
}

sig ClienteConvenio extends Cliente{
		pedido: one DroneConvenio
}

sig DroneConvenio extends Drone{}

sig DroneNormal extends Drone{}


fun livrosDoDroneConvenio[dc: DroneConvenio]: set Livro {
	dc.livrosComprados
	
}

fun livrosDoDroneNormal[dn: DroneNormal]: set Livro{
	dn.livrosComprados
}

fact {
	all dc: DroneConvenio | #livrosDoDroneConvenio[dc] < 6

}

fact{
	all dn:DroneNormal | #livrosDoDroneNormal[dn] < 4


}

fact relacaoDroneLivro{
	#DroneNormal = 3
	all d:Drone | #(d.livrosComprados) < 4

}

fact relacaoDroneConvenioLivro {
	#DroneConvenio = 2
	all d:Drone | #(d.livrosComprados) < 6

}

//fact relacaoDroneLivro {
//	all c:Cliente | #(c.pedido) = 0 => #(c.pedido.livrosComprados) = 0
//	#(Livro.~livrosComprados) = 1
//	#(Drone.~pedido) = 1
//}


pred show[]{}

run show for 5
