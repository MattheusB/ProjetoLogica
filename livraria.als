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
 pedidoCliente: lone PedidoNormal

}

sig ClienteConvenio extends Cliente{
 pedidoCliente: lone PedidoConvenio

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

fun pedidosClienteNormal[cn: ClienteNormal]: set PedidoNormal {
	cn.pedidoCliente
}

fun pedidosClienteConvenio[cc: ClienteConvenio]: set PedidoConvenio{
	cc.pedidoCliente
}
//Relacao de Cliente e Pedido de 1 para 1, cada cliente so pode ter um pedido por vez
fact relacaoClientePedido{
 all cn: ClienteNormal | lone pn: PedidoNormal{
 	cn.pedidoCliente = pn
 }
 all cc: ClienteConvenio | lone pc: PedidoConvenio{
 	cc.pedidoCliente = pc
 }
}

fact {
 all pc: PedidoConvenio | #livrosPedidoConvenio[pc] > 3
 all pc: PedidoConvenio | #livrosPedidoConvenio[pc] < 6
 all pc: PedidoConvenio | one cc: ClienteConvenio{
 	cc.pedidoCliente = pc
 }
 all pc: PedidoConvenio | one dc: DroneConvenio{
 	dc.pedidoConvenio = pc
 }

}

fact relacaoPedidoNormal{
 all pn: PedidoNormal | #livrosPedidoNormal[pn] < 4
 //Pedido so existe se tiver um cliente.
 all pn: PedidoNormal | one cn: ClienteNormal{
 	cn.pedidoCliente = pn
 }
 all pn: PedidoNormal | one dn: DroneNormal{
 	dn.pedidoNormal = pn
 }
  
}




fact relacaoDroneNormal{
 all dn: DroneNormal | one cn: ClienteNormal{
 		DroneClienteNORMAL[dn, cn]
 	}
}

fact relacaoDroneConvenio{
 all dc: DroneConvenio | one cc: ClienteConvenio{
 		DroneClienteCONVENIO[dc, cc]
 	}
}

pred DroneClienteNORMAL[dn: DroneNormal, cn: ClienteNormal] {
  dn.pedidoNormal in cn.pedidoCliente
}

pred DroneClienteCONVENIO[dc: DroneConvenio, cc: ClienteConvenio] {
  dc.pedidoConvenio in cc.pedidoCliente
}



fact relacaoDroneConvenio{
 all dc: DroneConvenio | one cc: ClienteConvenio{
 	dc.pedidoConvenio in cc.pedidoCliente
 	}
}




fact {
 #DroneNormal = 3
 #DroneConvenio = 2
  

}

assert clienteNormalUm {
	all cn: ClienteNormal | #pedidosClienteNormal[cn] = 1

}


assert clienteNormalZero {
	all cn: ClienteNormal | #pedidosClienteNormal[cn] = 0

}

assert clienteNormalErrado {
	all cn: ClienteNormal | #pedidosClienteNormal[cn] = 2
}

assert pedidoNormalTres {
	all pn: PedidoNormal | #livrosPedidoNormal[pn] > 4

}




pred show[]{}

run show for 13 but exactly 5 ClienteNormal, exactly 10 ClienteConvenio
