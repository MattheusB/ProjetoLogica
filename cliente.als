module loja

abstract sig Cliente{
	

}

sig Livro{

}
sig Pedido {
	
}

abstract sig  Drone{

}

sig ClienteNormal extends Cliente{
	livrosPedidos: lone PedidoNormal

}

sig ClienteConvenio extends Cliente{
	livrosPedidos: lone PedidoConvenio

}

sig DroneConvenio extends Drone{
		pedido: lone PedidoConvenio

}

sig DroneNormal extends Drone{
		pedido: lone PedidoNormal

}

sig PedidoNormal extends Pedido{
	livrosComprados: some Livro

}

sig PedidoConvenio extends Pedido{
	livrosComprados: some Livro

}


fun livrosPedidoNormal[pn: PedidoNormal]: set Livro {
	pn.livrosComprados
	
}

fun livrosPedidoConvenio[pc: PedidoConvenio]: set Livro{
	pc.livrosComprados
}

fact {
	all pc: PedidoConvenio | #livrosPedidoConvenio[pc] > 3
	all pc: PedidoConvenio | #livrosPedidoConvenio[pc] < 6

}

fact{
	all pn: PedidoNormal | #livrosPedidoNormal[pn] < 4


}


//fact {
//	all d: Drone | one p: Pedido{
//	d.livrosPedidos in p.livrosPedidos
//	}

//}


fact {
	#DroneNormal = 3
	#DroneConvenio = 2
	

}



pred show[]{}

run show for 5
