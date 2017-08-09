module loja

sig Cliente{
	pedido: one Drone
}

sig Livro{}

abstract sig  Drone{
	livrosComprados: set Livro
}

sig ClienteConvenio in Cliente{
	
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


pred show[]{}

run show for 5
