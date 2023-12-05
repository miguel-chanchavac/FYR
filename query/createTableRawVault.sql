drop table if exists raw_vault.hub_cuenta;

create table if not exists raw_vault.hub_cuenta
(
cuenta_hashkey varchar(32) primary key not null,
load_date timestamp not null,
record_source varchar(50) not null,
cuenta_id varchar(30) not null
);

create index idx_cuenta_id on raw_vault.hub_cuenta(cuenta_id);

create table if not exists raw_vault.hub_empresa
(
empresa_hashkey varchar(32) primary key not null,
load_date timestamp not null,
record_source varchar(50) not null,
empresa_id varchar(30) not null
);

create index idx_empresa_id on raw_vault.hub_empresa(empresa_id);

create table if not exists raw_vault.hub_cheque
(
cheque_hashkey varchar(32) primary key not null,
load_date timestamp not null,
record_source varchar(50) not null,
cheque_id varchar(30) not null
);

create index idx_cheque_id on raw_vault.hub_cheque(cheque_id);

create table if not exists raw_vault.hub_factura
(
factura_hashkey varchar(32) primary key not null,
load_date timestamp not null,
record_source varchar(50) not null,
factura_id varchar(30) not null
);

create index idx_factura_id on raw_vault.hub_factura(factura_id);

create table if not exists raw_vault.hub_proveedor
(
proveedor_hashkey varchar(32) primary key not null,
load_date timestamp not null,
record_source varchar(50) not null,
proveedor_id varchar(30) not null
);

create index idx_proveedor_id on raw_vault.hub_proveedor(proveedor_id);


create table if not exists raw_vault.link_cuenta_empresa
(
cuenta_empresa_hashkey varchar(32) not null,
load_date timestamp not null,
record_source varchar(50) not null,
cuenta_hashkey varchar(32) not null,
empresa_hashkey varchar(32) not null,
constraint cuenta_empresa_hashkey_pkey primary key (cuenta_empresa_hashkey),
constraint cuenta_hashkey_fkey foreign key (cuenta_hashkey) references raw_vault.hub_cuenta(cuenta_hashkey),
constraint empresa_hashkey_fkey foreign key (empresa_hashkey) references raw_vault.hub_empresa(empresa_hashkey)
);


create table if not exists raw_vault.link_cuenta_cheque
(
cuenta_cheque_hashkey varchar(32) not null,
load_date timestamp not null,
record_source varchar(50) not null,
cuenta_hashkey varchar(32) not null,
cheque_hashkey varchar(32) not null,
constraint cuenta_cheque_hashkey_pkey primary key (cuenta_cheque_hashkey),
constraint cuenta_hashkey_fkey foreign key (cuenta_hashkey) references raw_vault.hub_cuenta(cuenta_hashkey),
constraint cheque_hashkey_fkey foreign key (cheque_hashkey) references raw_vault.hub_cheque(cheque_hashkey)
);


create table if not exists raw_vault.link_proveedor_cheque
(
proveedor_cheque_hashkey varchar(32) not null,
load_date timestamp not null,
record_source varchar(50) not null,
proveedor_hashkey varchar(32) not null,
cheque_hashkey varchar(32) not null,
constraint proveedor_cheque_hashkey_pkey primary key (proveedor_cheque_hashkey),
constraint proveedor_hashkey_fkey foreign key (proveedor_hashkey) references raw_vault.hub_proveedor(proveedor_hashkey),
constraint cheque_hashkey_fkey foreign key (cheque_hashkey) references raw_vault.hub_cheque(cheque_hashkey)
);


create table if not exists raw_vault.link_proveedor_factura
(
proveedor_factura_hashkey varchar(32) not null,
load_date timestamp not null,
record_source varchar(50) not null,
proveedor_hashkey varchar(32) not null,
factura_hashkey varchar(32) not null,
constraint proveedor_factura_hashkey_pkey primary key (proveedor_factura_hashkey),
constraint proveedor_hashkey_fkey foreign key (proveedor_hashkey) references raw_vault.hub_proveedor(proveedor_hashkey),
constraint factura_hashkey_fkey foreign key (factura_hashkey) references raw_vault.hub_factura(factura_hashkey)
);


create table if not exists raw_vault.ref_sat_calendario
(
"date" date primary key not null,
load_date timestamp not null,
anio integer not null,
mes integer not null,
dia integer not null,
semana integer not null,
dia_semana integer not null,
nombre_dia varchar(10) not null
);

drop table if exists raw_vault.sat_cuenta;

create table if not exists raw_vault.sat_cuenta
(
cuenta_hashkey varchar(32) not null,
load_date timestamp not null,
load_end_date timestamp not null,
record_source varchar(50) not null,
hash_diff varchar(32) not null,
cuenta_id varchar(30) not null,
nombre_cuenta varchar(150) not null,
cuenta_consolidadora varchar(100),
cuenta_resultados_consolidados varchar(100),
tipo_cuenta varchar(50),
clasificacion varchar(20),
estado_financiero varchar(20),
numero varchar(10),
tipo_moneda char(3),
regimen 
constraint cuenta_hashkey_load_date_pkey primary key(cuenta_hashkey, load_date),
constraint cuenta_hashkey_fkey foreign key (cuenta_hashkey) references raw_vault.hub_cuenta(cuenta_hashkey)
);


create table if not exists raw_vault.sat_proveedor
(
proveedor_hashkey varchar(32) not null,
load_date timestamp not null,
load_end_date timestamp not null,
record_source varchar(50) not null,
hash_diff varchar(32) not null,
nit varchar(15),
nombre_proveedor varchar(150),
)

