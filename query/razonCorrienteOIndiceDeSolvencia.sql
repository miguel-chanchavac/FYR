--RAZON FINANCIERA
--Razon corriente o Indice de Solvencia
--Capacidad que tiene la empresa con sus activos a corto plazo o circulante, para cubrir sus deudas de corto plazo.


drop table stage.estado_financiero;

--inserto datos de activo corrientes
create table stage.estado_financiero as
with activos_corrientes as (
select 
	posicion ,
	cuenta_resumen ,
	'activos_corrientes' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber) as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('1.8', '1.5', '1.4', '1.6', '1.7', '1.9')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from activos_corrientes


--inserto datos de pasivo corrientes
insert into stage.estado_financiero
with pasivo_corriente as (
select 
	posicion ,
	cuenta_resumen ,
	'pasivos_corrientes' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('4.3','4.4','4.5','4.6','4.7')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from pasivo_corriente

insert into stage.estado_financiero
with costos as (
select 
	posicion ,
	cuenta_resumen ,
	'costo_produccion' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber) as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('5')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from costos

insert into stage.estado_financiero
with costos as (
select 
	posicion ,
	cuenta_resumen ,
	'ingreso' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber) as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('4')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from costos


--inserto datos de pasivo corrientes
insert into stage.estado_financiero
with pasivo_no_corriente as (
select 
	posicion ,
	cuenta_resumen ,
	'pasivos_no_corrientes' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('4.1','4.2')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from pasivo_no_corriente


insert into stage.estado_financiero
with activo_no_corriente as (
select 
	posicion ,
	cuenta_resumen ,
	'activos_no_corrientes' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('1.1','1.2','1.2.1','1.3')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from activo_no_corriente



insert into stage.estado_financiero
with activo_no_corriente as (
select 
	posicion ,
	cuenta_resumen ,
	'activos_no_corrientes' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('1.1','1.2','1.2.1','1.3')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from activo_no_corriente


insert into stage.estado_financiero
with capital as (
select 
	posicion ,
	cuenta_resumen ,
	'capital_reserva' as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
--and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('3.1','3.3','3.2','3.4','3.5','3.6')
group by posicion ,
cuenta_resumen ,
to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select * from capital


insert into stage.estado_financiero
with margen_bruto_gasto_operacion as (
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
select 
	posicion ,
	cuenta_resumen ,
	nombre_cuenta as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('13','6.1','6.2','10','9', '7')
group by posicion ,
cuenta_resumen,
nombre_cuenta
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')
)
select 
	'3.7' as posicion,
	'ganancia_perdida_acumulada_del_periodo' as cuenta_resumen,
	'capital_reserva' as tipo_cuenta,
	fecha_operacion,
	sum(monto) as monto
from margen_bruto_gasto_operacion
group by fecha_operacion;


delete from stage.estado_financiero
where posicion = '3.7';




select 
	posicion ,
	cuenta_resumen ,
	nombre_cuenta as tipo_cuenta,
	to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd') as fecha_operacion,
	sum(saldo_inicial+debe-haber)*-1 as monto
from stage.stage_ingreso_historia sih
where 1=1 
and posicion in ('13','6.1','6.2','10','9')
group by posicion ,
cuenta_resumen,
nombre_cuenta
,to_date(to_char(fecha_operacion, 'yyyy-MM-')||'01', 'yyyy-MM-dd')



select * from stage.stage_ingreso_historia where posicion = '3.7'



select * from stage.stage_ingreso_historia
where posicion in ('13','6.1','6.2','10','9')
