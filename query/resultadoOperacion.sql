with ingresos as (
select 
	posicion ,
	cuenta_resumen ,
	'ingresos' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('4')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from ingresos


with costo_produccion as (
select 
	posicion ,
	cuenta_resumen ,
	'costo_produccion' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('5')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from costo_produccion


with otros_ingresos as (
select 
	posicion ,
	cuenta_resumen ,
	'otros ingresos' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('13')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from otros_ingresos


with gastos_de_operacion as (
select 
	posicion ,
	cuenta_resumen ,
	'gastos de operacion' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('6.1','6.2','10','9')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from gastos_de_operacion


drop view stage.resultado_operacion;

--vista de resultado de operacion
--ingresos
create view stage.resultado_operacion as
select 
	posicion ,
	cuenta_resumen ,
	'ingresos' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('4')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
union all
--costos de produccion
select 
	posicion ,
	cuenta_resumen ,
	'costo_produccion' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('5')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
union all
--otros ingresos
select 
	posicion ,
	cuenta_resumen ,
	'otros ingresos' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('13')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
union all
--gastos de operacion
select 
	posicion ,
	cuenta_resumen ,
	'gastos de operacion' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('6.1','6.2','10','9')
group by posicion ,
cuenta_resumen
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')




with costo_porcentaje as (
select 
	'resultado' as tipo_cuenta,
	sum(case 
		when cuenta_resumen = 'VENTAS LOCALES' then monto else 0 
	end) as monto_ventas,
	sum(case
		when cuenta_resumen = 'COSTO DE PRODUCCION' then monto*-1 else 0 
	end) as monto_costo
from stage.resultado_operacion
where cuenta_resumen in ('VENTAS LOCALES', 'COSTO DE PRODUCCION')
)
select 
	tipo_cuenta,
	monto_ventas,
	monto_costo,
	round(monto_costo/monto_ventas,4) as porcentaje
from costo_porcentaje



