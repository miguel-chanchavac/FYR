drop table if exists stage.stage_ingreso_2022;

create table if not exists stage.stage_ingreso_2022
(
poliza varchar(12),
cheque varchar(25),
tran varchar(3),
fecha_operacion varchar(20),
mes_operacion decimal(3,1),
monto decimal(18,2),
cuenta decimal(11,1),
nombre_cuenta varchar(150),
cuenta_consolidadora varchar(150),
cuenta_resumen varchar(150),
estado_financiero varchar(10),
posicion varchar(5),
clasificacion char(1),
debe decimal(18,2),
haber decimal(18,2),
serie_factura varchar(40),
no_factura varchar(25),
fecha_factura varchar(20),
nit varchar(20),
nombre_proveedor varchar(150),
regimen varchar(50),
libro varchar(15),
tipo_doc varchar(15),
factura_compras varchar(25),
tipo_registro varchar(25),
galones decimal(18,2),
tipo_combustible char(1),
servicio decimal(18,2),
bien_compras decimal(18,2),
servicio_ventas decimal(18,2),
bien_ventas decimal(18,2),
combustible decimal(18,2),
importacion decimal(18,2),
exportacion decimal(18,2),
excento decimal(18,2),
compra_servicio_pc decimal(18,2),
idp decimal(18,2),
iva_lc_lv decimal(18,2),
total decimal(18,2),
comentario varchar(300),
nombre_poliza varchar(150),
debe_2 decimal(18,2),
haber_2 decimal(18,2),
saldo_inicial decimal(18,2)
);


create table if not exists stage.nomenclatura
(
codigo decimal(11,1),
cuenta_consolidada varchar(150),
cuenta_resultados_consolidados varchar(150),
nombre_a_mostrar varchar(150),
tipo_cuenta varchar(50),
clasificacion varchar(50),
estado_financiero varchar(50),
numero varchar(5),
moneda char(3)
);

copy stage.nomenclatura from '/Users/mangeluz/Documents/transformacionDigital/empresas/FYR/codigo/Nomenclatura_2023.csv' with delimiter ',' csv header;

select * from stage.nomenclatura

drop table stage.stage_ingreso_historia_2022;

create table if not exists stage.stage_ingreso_historia_2022
(
poliza varchar(12),
cheque varchar(25),
tran varchar(3),
fecha_operacion date,
mes_operacion decimal(3,1),
monto decimal(18,2),
cuenta decimal(11,1),
nombre_cuenta varchar(150),
cuenta_consolidadora varchar(150),
cuenta_resumen varchar(150),
estado_financiero varchar(10),
posicion varchar(5),
clasificacion char(1),
debe decimal(18,2),
haber decimal(18,2),
serie_factura varchar(15),
no_factura varchar(25),
fecha_factura date,
nit varchar(20),
nombre_proveedor varchar(150),
regimen varchar(50),
libro varchar(15),
tipo_doc varchar(15),
factura_compras varchar(25),
tipo_registro varchar(25),
galones decimal(18,2),
tipo_combustible char(1),
servicio decimal(18,2),
bien_compras decimal(18,2),
servicio_ventas decimal(18,2),
bien_ventas decimal(18,2),
combustible decimal(18,2),
importacion decimal(18,2),
exportacion decimal(18,2),
excento decimal(18,2),
compra_servicio_pc decimal(18,2),
idp decimal(18,2),
iva_lc_lv decimal(18,2),
total decimal(18,2),
comentario varchar(300),
nombre_poliza varchar(150),
debe_2 decimal(18,2),
haber_2 decimal(18,2),
saldo_inicial decimal(18,2)
);

truncate table stage.stage_ingreso;

copy stage.stage_ingreso from '/Users/mangeluz/Documents/transformacionDigital/empresas/FYR/Ingreso_2023.csv' with delimiter ',' csv header;
copy stage.stage_ingreso_2022 from '/Users/mangeluz/Documents/transformacionDigital/empresas/FYR/codigo/Ingreso_2022.csv' with delimiter ',' csv header;



insert into stage.stage_ingreso_historia
select 
poliza,
cheque,
tran,
fecha_operacion,
mes_operacion,
monto,
cuenta,
upper(nombre_cuenta) as nombre_cuenta,
upper(cuenta_consolidadora) as cuenta_consolidadora,
upper(cuenta_resumen) as cuenta_resumen,
upper(estado_financiero) as estado_financiero,
posicion,
clasificacion,
debe,
haber,
serie_factura,
no_factura,
fecha_factura,
nit,
upper(nombre_proveedor) as nombre_proveedor,
upper(regimen) as regimen,
upper(libro) as libro,
upper(tipo_doc) as tipo_doc,
factura_compras,
upper(tipo_registro) as tipo_registro,
galones,
tipo_combustible,
servicio,
bien_compras,
servicio_ventas,
bien_ventas,
combustible,
importacion,
exportacion,
excento,
compra_servicio_pc,
idp,
iva_lc_lv,
total,
upper(comentario) as comentario,
upper(nombre_poliza) as nombre_poliza,
debe_2,
haber_2,
saldo_inicial
from stage.stage_ingreso
where poliza is not null;



select 
poliza,
cheque,
tran,
to_date(fecha_operacion
) as fecha_operacion,
mes_operacion,
monto,
cuenta,
upper(nombre_cuenta) as nombre_cuenta,
upper(cuenta_consolidadora) as cuenta_consolidadora,
upper(cuenta_resumen) as cuenta_resumen,
upper(estado_financiero) as estado_financiero,
posicion,
clasificacion,
debe,
haber,
serie_factura,
no_factura,
fecha_factura,
nit,
upper(nombre_proveedor) as nombre_proveedor,
upper(regimen) as regimen,
upper(libro) as libro,
upper(tipo_doc) as tipo_doc,
factura_compras,
upper(tipo_registro) as tipo_registro,
galones,
tipo_combustible,
servicio,
bien_compras,
servicio_ventas,
bien_ventas,
combustible,
importacion,
exportacion,
excento,
compra_servicio_pc,
idp,
iva_lc_lv,
total,
upper(comentario) as comentario,
upper(nombre_poliza) as nombre_poliza,
debe_2,
haber_2,
saldo_inicial
from stage.stage_ingreso_2022
where poliza is not null;






select 
  fecha_operacion,
  sum(debe) as debe,
  sum(haber) as haber
from stage.stage_ingreso_historia 
group by fecha_operacion



select * from stage.stage_ingreso_historia
where fecha_operacion is null

select 
	sum(debe) as debe, 
	sum(haber) as haber,
	sum(debe_2) as debe_2 ,
	sum(haber_2) as haber_2 
from stage.stage_ingreso_historia;


select 
	fecha_operacion,
	posicion,
	cuenta_resumen ,
	sum(monto)
from stage.stage_ingreso_historia
where cuenta_resumen in (
	'VENTAS LOCALES'
	)
and to_char(fecha_operacion, 'yyyy') = '2023'
and estado_financiero = 'RESULTADOS'
group by fecha_operacion, posicion , cuenta_resumen 


with temp as (
select 
	posicion ,
	cuenta_resumen ,
	sum(monto) as MONTO,
	sum(debe) as debe 
from stage.stage_ingreso_historia
where cuenta_resumen in (
	'COSTO DE PRODUCCION'
	)
and to_char(fecha_operacion, 'yyyy') = '2023'
and mes_operacion = 5
and estado_financiero = 'RESULTADOS'
group by 1,2
)
select * from temp



with ventas_locales as (
select 
	fecha_operacion,
	to_char(fecha_operacion, 'yyyy') as anio,
	to_char(fecha_operacion, 'MM') as mes,
	to_char(fecha_operacion, 'dd') as dia,
	posicion,
	cuenta_resumen ,
	sum(monto) as monto
from stage.stage_ingreso_historia
where cuenta_resumen in (
	'VENTAS LOCALES'
	)
and to_char(fecha_operacion, 'yyyy') = '2023'
and estado_financiero = 'RESULTADOS'
group by fecha_operacion, posicion , cuenta_resumen 
),
otras_cuentas
select * from ventas_locales





with cuenta_resumen as (
select 
	fecha_operacion,
	to_char(fecha_operacion, 'yyyy') as anio,
	to_char(fecha_operacion, 'MM') as mes,
	to_char(fecha_operacion, 'dd') as dia,
	posicion,
	cuenta_resumen ,
	sum(monto) as monto
from stage.stage_ingreso_historia
where cuenta_resumen in (
	'VENTAS LOCALES'
	)
and to_char(fecha_operacion, 'yyyy') = '2023'
and estado_financiero = 'RESULTADOS'
group by fecha_operacion, posicion , cuenta_resumen 
union all
select 
	fecha_operacion,
	to_char(fecha_operacion, 'yyyy') as anio,
	to_char(fecha_operacion, 'MM') as mes,
	to_char(fecha_operacion, 'dd') as dia,
	posicion,
	cuenta_resumen ,
	sum(case when clasificacion = 'D' then debe*-1 else 0 end) as monto
from stage.stage_ingreso_historia
where cuenta_resumen not in (
	'VENTAS LOCALES'
	)
and to_char(fecha_operacion, 'yyyy') = '2023'
and estado_financiero = 'RESULTADOS'
group by fecha_operacion, posicion , cuenta_resumen 
)
select 
	mes,
	sum(monto) as monto
from cuenta_resumen
where cuenta_resumen in ('COSTO DE PRODUCCION')
group by 1




select cuenta_resumen , sum(monto) as monto, row_number () over(partition by cuenta_resumen order by fecha_operacion) as ranker
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
and estado_financiero = 'RESULTADOS'
group by cuenta_resumen , fecha_operacion 



select distinct cuenta_resumen 
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
--and estado_financiero = 'RESULTADOS'
--and cuenta_resumen like '%PRESTA%'


--CA Activos Corrientes
CUENTAS POR COBRAR A EMPLEADOS
CAJA Y BANCOS
IMPUESTOS POR COBRAR

--CL Pasivos Corrientes
IMPUESTOS POR PAGAR
SUELDOS Y SALARIOS POR PAGAR



with activos_corrientes as (
select 
	to_char(fecha_operacion, 'yyyy') as anio,
	to_char(fecha_operacion, 'MM') as mes,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
and cuenta_resumen in (
	'IMPUESTOS POR PAGAR',
	'SUELDOS Y SALARIOS POR PAGAR'
)
group by 
	to_char(fecha_operacion, 'yyyy'),
	to_char(fecha_operacion, 'MM')
), pasivo_corriente as (
select 
	to_char(fecha_operacion, 'yyyy') as anio,
	to_char(fecha_operacion, 'MM') as mes,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
and cuenta_resumen in (
	'CUENTAS POR COBRAR A EMPLEADOS',
	'CAJA Y BANCOS',
	'IMPUESTOS POR COBRAR'
)
group by 
	to_char(fecha_operacion, 'yyyy'),
	to_char(fecha_operacion, 'MM')
)
select 
	coalesce(ac.anio, pc.anio) as anio,
	coalesce(ac.mes, pc.mes) as mes,
	coalesce(sum(ac.monto - pc.monto),0) as liquidez
from activos_corrientes ac
full join pasivo_corriente pc on (ac.anio = pc.anio and ac.mes = pc.mes)
group by  
coalesce(ac.anio, pc.anio), 
coalesce(ac.mes, pc.mes)










with activos_corrientes as (
select 
	fecha_operacion,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
and cuenta_resumen in (
	'CUENTAS POR COBRAR A EMPLEADOS',
	'CAJA Y BANCOS',
	'IMPUESTOS POR COBRAR'
)
group by fecha_operacion
), pasivo_corriente as (
select 
	fecha_operacion,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
and cuenta_resumen in (
	'IMPUESTOS POR PAGAR',
	'SUELDOS Y SALARIOS POR PAGAR'
)
group by fecha_operacion
), tabla_liquidez as (
select 
	ac.fecha_operacion,
	coalesce(ac.monto,0) - coalesce(pc.monto,0) as monto
from activos_corrientes ac
full join pasivo_corriente pc on ac.fecha_operacion = pc.fecha_operacion
)
select
	fecha_operacion as fecha,
	SUM(tl.monto) as monto
from tabla_liquidez tl
where fecha_operacion is not null
group by fecha_operacion




select * from 
stage.stage_ingreso_historia sih
left join stage.nomenclatura n on sih.cuenta = n.codigo
where to_char(fecha_operacion, 'yyyy') = '2023'
and n.numero in ('1.2')




---PASIVO CORRIENTES
select 
	fecha_operacion,
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where 1=1
and to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('1.2')
group by fecha_operacion

--ACTIVOS CORRIENTES
select 
	sum(monto) as monto
from stage.stage_ingreso_historia sih 
where to_char(fecha_operacion, 'yyyy') = '2023'
and posicion in ('1.2')





select 
cuenta ,
nombre_cuenta ,
sum(saldo_inicial) as saldo_inicial,
sum(debe_2) as debe,
sum(haber_2) as haber
from stage.stage_ingreso_historia sih
where to_char(fecha_operacion, 'yyyyMM') = '202301'
and posicion in ('1.2')
group by 
cuenta ,
nombre_cuenta 


select 
*
from stage.stage_ingreso_historia sih
where to_char(fecha_operacion, 'yyyyMM') = '202301'
and posicion in ('1.2')


stage.stage_ingreso


select 
*
from stage.stage_ingreso sih
where to_char(fecha_operacion, 'yyyyMM') = '202301'
and posicion in ('1.2')