module loja

sig Loja{
	clientes: Cliente
}
sig Cliente{
	pedido: set Pedidos
}
sig Pedidos{
	livrosComprado: set Livro
}

sig Livro{}

sig Drones{}

sig ClienteConvenio in Cliente{}

fact{
	all  c:Cliente | #(c.pedido.livrosComprado) < 4
}



pred show[]{}

run show 
