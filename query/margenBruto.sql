--margen bruto
with ingresos as (
select 
	posicion ,
	cuenta_resumen ,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial)*-1 as saldo_inicial ,
	sum(debe)*-1 as debe ,
	sum(haber)*-1 as haber 
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('4')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select 
	posicion, 
	cuenta_resumen, 
	fecha_operacion,
	'ingresos' as tipo_cuenta,
	saldo_inicial+debe-haber as monto_ingreso
from ingresos


with costo_produccion as (
select 
	posicion ,
	cuenta_resumen ,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial) as saldo_inicial ,
	sum(debe) as debe ,
	sum(haber) as haber 
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('5')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select 
	posicion, 
	cuenta_resumen, 
	fecha_operacion,
	'costo_produccion' as tipo_cuenta,
	saldo_inicial+debe-haber as monto_costo
from costo_produccion



with ingresos as (
select 
	posicion ,
	cuenta_resumen ,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial)*-1 as saldo_inicial ,
	sum(debe)*-1 as debe ,
	sum(haber)*-1 as haber 
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('4')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
), ingresos_total as (
select 
	posicion, 
	cuenta_resumen, 
	fecha_operacion,
	'ingresos' as tipo_cuenta,
	saldo_inicial+debe-haber as monto_ingreso
from ingresos
), costo_produccion as (
select 
	posicion ,
	cuenta_resumen ,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial) as saldo_inicial ,
	sum(debe) as debe ,
	sum(haber) as haber 
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('5')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
), costo_produccion_total as (
select 
	posicion, 
	cuenta_resumen, 
	fecha_operacion,
	'costo_produccion' as tipo_cuenta,
	saldo_inicial+debe-haber as monto_costo
from costo_produccion
), margen_bruto as (
select 
	cpt.fecha_operacion,
	coalesce(it.monto_ingreso,0) as ventas,
	coalesce(it.monto_ingreso,0)-coalesce(cpt.monto_costo,0) as margen_bruto
	--round((coalesce(it.monto_ingreso,0)-coalesce(cpt.monto_costo,0))/coalesce(it.monto_ingreso,0),4) as porcentaje
from ingresos_total it
right join costo_produccion_total cpt on it.fecha_operacion = cpt.fecha_operacion
--where to_char(it.fecha_operacion, 'yyyy') = '2023'
)
select 
	fecha_operacion,
	margen_bruto,
	round(case when ventas <> 0 then margen_bruto/ventas else 0 end, 4) as porcentaje
from margen_bruto


