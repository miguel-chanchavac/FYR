create view stage.top_ventas_proveedor as

select 
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	nombre_proveedor ,
	row_number () over(partition by to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') order by sum(monto) desc) as ranker,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where posicion in ('4')
group by 
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd'),
	nombre_proveedor
	
	
select * from stage.top_ventas_proveedor


