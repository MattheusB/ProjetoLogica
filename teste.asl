module loja

abstract sig Cliente{
 	pedido: lone Drone
  }
  
sig Livro{}
  
 sig Drone{
 	livrosComprados: set Livro
 }
 
 sig ClienteConvenio in Cliente{
 	
 }
 
sig DroneConvenio in Drone{}
  
  
fact{
	#Drone = 3
 	some Cliente
	all c:Cliente | #(c.pedido.livrosComprados) < 4
 	//all c:Cliente | #(c.pedido.livrosComprados) = 0 => #(c.pedido) = 0
 	#(Livro.~livrosComprados) = 1
 	all d:Drone | #(d.~pedido) = 1
  }

pred show[]{}

run show for 5
