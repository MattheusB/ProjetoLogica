module loja

abstract sig Cliente{
  

}

sig Livro{

}
abstract sig Pedido {
  
}

abstract sig Drone{

}

sig ClienteNormal extends Cliente{
 livrosPedidos: lone PedidoNormal

}

sig ClienteConvenio extends Cliente{
 livrosPedidos: lone PedidoConvenio

}

sig DroneConvenio extends Drone{
 	pedidoConvenio: lone PedidoConvenio

}

sig DroneNormal extends Drone{
 	pedidoNormal: lone PedidoNormal

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
//Relacao de Cliente e Pedido de 1 para 1, cada cliente so pode ter um pedido por vez
fact relcaoClientePedido{
 all cn: ClienteNormal | one pn: PedidoNormal{
 	cn.livrosPedidos = pn
 }
 all cc: ClienteConvenio | one pc: PedidoConvenio{
 	cc.livrosPedidos = pc
 }
}

fact {
 all pc: PedidoConvenio | #livrosPedidoConvenio[pc] > 3
 all pc: PedidoConvenio | #livrosPedidoConvenio[pc] < 6
 all pc: PedidoConvenio | one cc: ClienteConvenio{
 	cc.livrosPedidos = pc
 }
 all pc: PedidoConvenio | one dc: DroneConvenio{
 	dc.pedidoConvenio = pc
 }

}

fact relacaoPedidoNormal{
 all pn: PedidoNormal | #livrosPedidoNormal[pn] < 4
 //Pedido so existe se tiver um cliente.
 all pn: PedidoNormal | one cn: ClienteNormal{
 	cn.livrosPedidos = pn
 }
 all pn: PedidoNormal | one dn: DroneNormal{
 	dn.pedidoNormal = pn
 }
  
}




fact relacaoDroneNormal{
 all dn: DroneNormal | one cn: ClienteNormal{
 	dn.pedidoNormal in cn.livrosPedidos
 	}
  
  
}




fact relacaoDroneConvenio{
 all dc: DroneConvenio | one cc: ClienteConvenio{
 	dc.pedidoConvenio in cc.livrosPedidos
 	}
}




fact {
 #DroneNormal = 3
 #DroneConvenio = 2
  

}



pred show[]{}

run show for 5
