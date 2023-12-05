/*
--RAZON FINANCIERA
--Razon rapida, de acidez o liquidez inmediata
--Presenta una prueba de liquidez más precisa, pues considera, los activos corrientes más líquidos, mide la capacidad 
de la empresa para liquidar sus obligaciones a corto plazo sin tomar en cuenta los inventarios
*/

--query para la Razon corriente o indice de solvencia
select 
	'2023' anio,
	sum(case when ef.tipo_cuenta = 'activos_corrientes' then ef.monto else 0 end) as activo_corriente,
	sum(case when ef.tipo_cuenta = 'pasivos_corrientes' then ef.monto else 0 end) as pasivo_corriente,
	round(sum(case when ef.tipo_cuenta = 'activos_corrientes' then ef.monto else 0 end)/
	sum(case when ef.tipo_cuenta = 'pasivos_corrientes' then ef.monto else 0 end),1) as indice_solvencia
from stage.estado_financiero ef
where tipo_cuenta in ('activos_corrientes', 'pasivos_corrientes')


--Razon rapida, de acidez o liquidez inmediata
select 
	'2023' anio,
	sum(case when ef.tipo_cuenta = 'activos_corrientes' then ef.monto else 0 end) as activo_corriente,
	sum(case when ef.tipo_cuenta = 'pasivos_corrientes' then ef.monto else 0 end) as pasivo_corriente,
	round(sum(case when ef.tipo_cuenta = 'activos_corrientes' then ef.monto else 0 end)/
	sum(case when ef.tipo_cuenta = 'pasivos_corrientes' then ef.monto else 0 end),1) as razon_rapida_acidez
from stage.estado_financiero ef
where tipo_cuenta in ('activos_corrientes', 'pasivos_corrientes')
and posicion != '1.4'


--capital de trabajo
select 
	'2023' anio,
	sum(case when ef.tipo_cuenta = 'activos_corrientes' then ef.monto else 0 end) as activo_corriente,
	sum(case when ef.tipo_cuenta = 'pasivos_corrientes' then ef.monto else 0 end) as pasivo_corriente,
	round(sum(case when ef.tipo_cuenta = 'activos_corrientes' then ef.monto else 0 end)-
	sum(case when ef.tipo_cuenta = 'pasivos_corrientes' then ef.monto else 0 end),1) as capital_trabajo
from stage.estado_financiero ef
where tipo_cuenta in ('activos_corrientes', 'pasivos_corrientes');

--ACTIVIDAD
--rotacion de inventario
select 
	'2023' anio,
	sum(case when ef.posicion = '1.4' then ef.monto else 0 end) as inventario,
	sum(case when ef.posicion = '5' then ef.monto else 0 end) as costo_produccion,
	round(sum(case when ef.posicion = '5' then ef.monto else 0 end)/
	sum(case when ef.posicion = '1.4' then ef.monto else 0 end),2) as rotacion_inventario
from stage.estado_financiero ef
where posicion in ('5', '1.4');

--rotacion de cuentas por cobrar
with operacion as (
select 
	'2023' anio,
	sum(case when ef.posicion = '1.5' then ef.monto*-1 else 0 end) as clientes,
	sum(case when ef.posicion = '4' then ef.monto else 0 end) as ventas_ingresos
from stage.estado_financiero ef
where posicion in ('4', '1.5')
)
select 
	anio,
	clientes,
	ventas_ingresos,
	round(case when ventas_ingresos = 0 then 0 else clientes / (ventas_ingresos / 360) end,2) as rotacion
from operacion


--rotacion de cuentas por pagar
with operacion as (
select 
	'2023' anio,
	sum(case when ef.posicion = '4.3' then ef.monto else 0 end) as proveedores,
	sum(case when ef.posicion = '5' then ef.monto else 0 end) as compras_costo
from stage.estado_financiero ef
where posicion in ('5', '4.3')
)
select 
	anio,
	proveedores,
	compras_costo,
	round(case when compras_costo = 0 then 0 else proveedores / (compras_costo / 360) end,2) as rotacion
from operacion


--rotacion de activos totales
with operacion as (
select 
	'2023' anio,
	sum(case when ef.posicion = '4' then ef.monto*-1 else 0 end) as ventas_ingresos,
	sum(case when ef.tipo_cuenta in ('activos_corrientes') then ef.monto else 0 end) + 
	sum(case when ef.tipo_cuenta in ('activos_no_corrientes') then ef.monto*-1 else 0 end) as activos_totales
	--round(sum(case when ef.posicion = '5' then ef.monto else 0 end)/
	--sum(case when ef.posicion = '1.4' then ef.monto else 0 end),2) as rotacion_inventario
from stage.estado_financiero ef
where posicion in ('4') or tipo_cuenta in ('activos_corrientes', 'activos_no_corrientes')
)
select 
	anio,
	ventas_ingresos,
	activos_totales,
	round(ventas_ingresos / activos_totales,2) as rotacion_activos_totales
from operacion
;

--endeudamiento
with operacion as (
select 
	'2023' anio,
	sum(case when ef.tipo_cuenta in ('activos_corrientes') then ef.monto else 0 end) + 
	sum(case when ef.tipo_cuenta in ('activos_no_corrientes') then ef.monto*-1 else 0 end) as activos_totales,
	sum(case when ef.tipo_cuenta in ('pasivos_corrientes', 'pasivos_no_corrientes') then ef.monto else 0 end) as pasivos_totales
from stage.estado_financiero ef
where tipo_cuenta in ('pasivos_corrientes', 'pasivos_no_corrientes', 'activos_corrientes', 'activos_no_corrientes')
)
select 
	anio,
	pasivos_totales,
	activos_totales,
	round(pasivos_totales / activos_totales,2) as rotacion_activos_totales
from operacion
;


--apalancamiento
with operacion as (
select 
	'2023' anio,
	sum(case when ef.tipo_cuenta in ('pasivos_corrientes', 'pasivos_no_corrientes') then ef.monto else 0 end) as pasivos_totales,
	sum(case when ef.posicion in ('3.1','3.2','3.3','3.4','3.5','3.6','3.7') then ef.monto else 0 end) as capital_contable
from stage.estado_financiero ef
where tipo_cuenta in ('pasivos_corrientes', 'pasivos_no_corrientes') 
or posicion in ('3.1','3.2','3.3','3.4','3.5','3.6','3.7')
)
select 
	anio,
	pasivos_totales,
	capital_contable,
	round(pasivos_totales / capital_contable,2) as rotacion_activos_totales
from operacion
;


--Estado de resultados
select 
	'2023' anio,
	case 
		when tipo_cuenta like 'activo%' then 'activo'
		when tipo_cuenta like 'pasivo%' then 'pasivo'
		when tipo_cuenta like 'capital%' then 'capital'
	end as tipo_cuenta,
	sum(monto) as monto
from stage.estado_financiero ef
where (tipo_cuenta like 'activo%'
	or tipo_cuenta like 'pasivo%'
	or tipo_cuenta like 'capital%'
)
group by case 
		when tipo_cuenta like 'activo%' then 'activo'
		when tipo_cuenta like 'pasivo%' then 'pasivo'
		when tipo_cuenta like 'capital%' then 'capital'
	end 




select * from stage.estado_financiero ef
where posicion = '3.7'





select 
	tipo_cuenta ,
	--cuenta_resumen ,
	sum(monto)
from stage.estado_financiero ef
--where tipo_cuenta in ('activos_corrientes', 'activos_no_corrientes')
where ef.posicion in ('3.1','3.3','3.2','3.4','3.5','3.6','3.7')
group by 1--,2
order by 1

select 
	tipo_cuenta ,
	cuenta_resumen ,
	sum(monto*-1)
from stage.estado_financiero ef
where tipo_cuenta in ('activos_no_corrientes')
group by 1,2
order by 1





select 
	sum(monto)
from stage.estado_financiero ef
where posicion in ('1.5')




