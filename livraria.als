module loja

abstract sig Cliente{}

sig Livro{}

abstract sig Pedido {}

abstract sig Drone{}

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
	all cn: ClienteNormal | #pedidosClienteNormal[cn] < 2
	all cn: ClienteNormal | lone pn: PedidoNormal{
 		PedidoClienteNORMAL[cn,pn]
	}

	all cc: ClienteConvenio | lone pc: PedidoConvenio{
 		PedidoClienteCONVENIO[cc,pc]
	}
}

fact relacaoPedidoConvenio{
	all pc: PedidoConvenio | #livrosPedidoConvenio[pc] > 3
	all pc: PedidoConvenio | #livrosPedidoConvenio[pc] < 6

	all pc: PedidoConvenio | one cc: ClienteConvenio{
 		PedidoClienteCONVENIO[cc,pc]
	}
	all pc: PedidoConvenio | one dc: DroneConvenio{
		DronePedidoCONVENIO[dc,pc]
	}
}

fact relacaoPedidoNormal{
	all pn: PedidoNormal | #livrosPedidoNormal[pn] < 4

	//Pedido so existe se tiver um cliente.
	all pn: PedidoNormal | one cn: ClienteNormal{
 		PedidoClienteNORMAL[cn,pn]
	}
 	all pn: PedidoNormal | one dn: DroneNormal{
 		DronePedidoNORMAL[dn,pn]
	}
}


fact relacaoDroneNormal{
	all dn: DroneNormal | one cn: ClienteNormal{
 		DroneClienteNORMAL[dn,cn]
	}
}

fact relacaoDroneConvenio{
	all dc: DroneConvenio | one cc: ClienteConvenio{
 		DroneClienteCONVENIO[dc,cc]
 	}
}

pred DroneClienteNORMAL[dn: DroneNormal, cn: ClienteNormal] {
	dn.pedidoNormal in cn.pedidoCliente
}

pred DroneClienteCONVENIO[dc: DroneConvenio, cc: ClienteConvenio] {
	dc.pedidoConvenio in cc.pedidoCliente
}

pred DronePedidoNORMAL[dn: DroneNormal, pn: PedidoNormal] {
	dn.pedidoNormal = pn
}

pred DronePedidoCONVENIO[dc: DroneConvenio, pc: PedidoConvenio] {
	dc.pedidoConvenio = pc
}

pred PedidoClienteNORMAL[cn: ClienteNormal, pn: PedidoNormal] {
	cn.pedidoCliente = pn
}

pred PedidoClienteCONVENIO[cc: ClienteConvenio, pc: PedidoConvenio] {
	cc.pedidoCliente = pc
}


fact quantidadeDrones {

	#DroneNormal = 3
	#DroneConvenio = 2
}

assert assertClienteNormal{
	all cn: ClienteNormal | #(cn.pedidoCliente) < 2 and #(cn.pedidoCliente) >-1
}

assert assertDroneConvenio {
	all dc: DroneConvenio | #(dc.pedidoConvenio) < 2 and #(dc.pedidoConvenio) > -1
}

assert assertClienteConvenio{
	all cc: ClienteConvenio | #(cc.pedidoCliente) < 2 and #(cc.pedidoCliente) > -1
}

assert assertDroneNormal {
	all dn: DroneNormal | #(dn.pedidoNormal) < 2 and #(dn.pedidoNormal) > -1
}


check assertClienteNormal for 5
check assertDroneConvenio for 5
check assertClienteConvenio for 5
check assertDroneNormal for 5




pred show[]{}

run show for 13 but exactly 5 ClienteNormal, exactly 10 ClienteConvenio
