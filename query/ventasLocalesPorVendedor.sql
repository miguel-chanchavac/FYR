select 
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	cuenta_resumen ,
	nombre_proveedor ,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where posicion in ('4')
group by 