with margen_neto as (
select 
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion ,
	sum(monto) as margen_neto
from stage.resultado_por_mes rpm 
group by 
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
), ventas as (
select 
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion ,
	sum(monto) as ventas
from stage.resultado_por_mes rpm 
where posicion in ('4')
group by 
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select 
	mn.fecha_operacion,
	mn.margen_neto,
	round((mn.margen_neto/v.ventas),4) as porcentaje
from margen_neto mn
inner join ventas v on mn.fecha_operacion = v.fecha_operacion