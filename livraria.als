module loja

sig Livro{}

abstract sig Cliente{}

//Cliente normal pode realizar ou nao um pedido.
sig ClienteNormal extends Cliente{
	pedidoCliente: lone PedidoNormal
}

//Cliente conveniado pode realizar ou nao um pedido.
sig ClienteConvenio extends Cliente{
	pedidoCliente: lone PedidoConvenio
}

abstract sig Drone{}

//Drone normal pode estar ou nao associado a um pedido.
sig DroneNormal extends Drone{
	pedidoNormal: lone PedidoNormal
}

//Drone especial pode estar ou nao associado a um pedido.
sig DroneConvenio extends Drone{
	pedidoConvenio: lone PedidoConvenio
}

//Pedido tem pelo menos um livro.
abstract sig Pedido{
	livrosComprados: some Livro
}

//Pedido para cliente normal.
sig PedidoNormal extends Pedido{}

//Pedido para cliente conveniado.
sig PedidoConvenio extends Pedido{}

//Funcao retorna o pedido do cliente normal.
fun pedidosClienteNormal[cn: ClienteNormal]: set PedidoNormal{
	cn.pedidoCliente
}

//Funcao retorna o pedido do cliente conveniado.
fun pedidosClienteConvenio[cc: ClienteConvenio]: set PedidoConvenio{
	cc.pedidoCliente
}

//Funcao retorna o set de livros comprados do pedido normal.
fun livrosPedidoNormal[pn: PedidoNormal]: set Livro{
	pn.livrosComprados
}

//Funcao retorna o set de livros comprados do pedido conveniado.
fun livrosPedidoConvenio[pc: PedidoConvenio]: set Livro{
	pc.livrosComprados
}

//Relacao de Cliente e Pedido de 1 para 1, cada cliente so pode ter um pedido por vez.
fact relacaoClientePedido{
	//Cliente so pode realizar um pedido simultaneamente.
	all cn: ClienteNormal | #pedidosClienteNormal[cn] < 2

	//Cliente normal pode ter ou nao um pedido normal associado.
	all cn: ClienteNormal | lone pn: PedidoNormal{
 		PedidoClienteNORMAL[cn,pn]
	}

	//Cliente conveniado pode ter ou nao um pedido conveniado associado.
	all cc: ClienteConvenio | lone pc: PedidoConvenio{
 		PedidoClienteCONVENIO[cc,pc]
	}
}

//Relacao do pedido com cliente normal e drone normal.
fact relacaoPedidoNormal{
	//Drone normal pode carregar ate 3 livros simultaneamente.
	all pn: PedidoNormal | #livrosPedidoNormal[pn] < 4

	//Pedido so existe se tiver um cliente normal.
	all pn: PedidoNormal | one cn: ClienteNormal{
 		PedidoClienteNORMAL[cn,pn]
	}
	//Pedido so existe se tiver um drone normal disponivel.
 	all pn: PedidoNormal | one dn: DroneNormal{
 		DronePedidoNORMAL[dn,pn]
	}	
}

//Relacao do pedido com cliente conveniado e drone especial.
fact relacaoPedidoConvenio{
	//Drone especial pode carregar ate 5 livros simultaneamente.
	all pc: PedidoConvenio | #livrosPedidoConvenio[pc] > 3
	all pc: PedidoConvenio | #livrosPedidoConvenio[pc] < 6

	//Pedido so existe se tiver um cliente conveniado.
	all pc: PedidoConvenio | one cc: ClienteConvenio{
 		PedidoClienteCONVENIO[cc,pc]
	}

	//Pedido so existe se tiver um drone especial disponivel.
	all pc: PedidoConvenio | one dc: DroneConvenio{
		DronePedidoCONVENIO[dc,pc]
	}	
}

//Um livro esta associado apenas a um pedido ou esta guardado no armazem.
fact relacaoLivroComPedido{
	all livro:Livro| lone livro.~livrosComprados
}

//Um drone normal esta associado apenas a um cliente normal ou esta guardado no armazem.
fact relacaoDroneNormal{
	all dn: DroneNormal | lone cn: ClienteNormal{
 		DroneClienteNORMAL[dn,cn]
	}
}

//Um drone especial esta associado apenas a um cliente conveniado ou esta guardado no armazem.
fact relacaoDroneConvenio{
	all dc: DroneConvenio | lone cc: ClienteConvenio{
 		DroneClienteCONVENIO[dc,cc]
 	}
}

//Pedido do drone normal esta ligado ao pedido do cliente normal.
pred DroneClienteNORMAL[dn: DroneNormal, cn: ClienteNormal] {
	dn.pedidoNormal in cn.pedidoCliente
}

//Pedido do drone especial esta ligado ao pedido do cliente conveniado.
pred DroneClienteCONVENIO[dc: DroneConvenio, cc: ClienteConvenio] {
	dc.pedidoConvenio in cc.pedidoCliente
}

//Drone normal recebe um pedido.
pred DronePedidoNORMAL[dn: DroneNormal, pn: PedidoNormal] {
	dn.pedidoNormal = pn
}

//Drone especial recebe um pedido.
pred DronePedidoCONVENIO[dc: DroneConvenio, pc: PedidoConvenio] {
	dc.pedidoConvenio = pc
}

//Cliente normal e associado a um pedido.
pred PedidoClienteNORMAL[cn: ClienteNormal, pn: PedidoNormal] {
	cn.pedidoCliente = pn
}

//Cliente conveniado e associado a um pedido.
pred PedidoClienteCONVENIO[cc: ClienteConvenio, pc: PedidoConvenio] {
	cc.pedidoCliente = pc
}

//Quantidade de drones disponiveis no armazem.
fact quantidadeDrones {
	#DroneNormal = 3
	#DroneConvenio = 2
}

assert assertClienteNormal{
	all cn: ClienteNormal | #(cn.pedidoCliente) < 2 and #(cn.pedidoCliente) > -1
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

--check assertClienteNormal for 5
--check assertDroneConvenio for 5
--check assertClienteConvenio for 5
--check assertDroneNormal for 5

pred show[]{}

run show for 13 but exactly 5 ClienteNormal, exactly 10 ClienteConvenio
