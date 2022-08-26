create database if not exists taxi_2;

use taxi_2;



DROP TABLE IF EXISTS  clima_conditions;
CREATE TABLE IF NOT EXISTS clima_conditions ( #tabla 1
        IdCondiciones     INT NOT NULL AUTO_INCREMENT,
        conditions varchar(25),
        PRIMARY KEY (IdCondiciones)
);



DROP TABLE IF EXISTS  borough;
CREATE TABLE IF NOT EXISTS borough ( #tabla 2
	IdBorough     INT NOT NULL AUTO_INCREMENT,
    Borough VARCHAR(25),
    #Latidud double, estas las agregamos despues
    #Longitud double,
    PRIMARY KEY (IdBorough)
);


DROP TABLE IF EXISTS  vendor;
CREATE TABLE IF NOT EXISTS vendor ( #tabla 3
	IdVendor     INT NOT NULL AUTO_INCREMENT,
    Vendor varchar(50),
    PRIMARY KEY (IdVendor)
);


DROP TABLE IF EXISTS  ratecode;
CREATE TABLE IF NOT EXISTS ratecode ( #tabla 4
	IdRateCode     INT NOT NULL AUTO_INCREMENT,
    RateCode VARCHAR(50),
    PRIMARY KEY (IdRateCode)
);



DROP TABLE IF EXISTS  payment_type;
CREATE TABLE IF NOT EXISTS payment_type ( #tabla 5
    IdPayment_Type     INT NOT NULL AUTO_INCREMENT,
    Payment VARCHAR(50),
    PRIMARY KEY (IdPayment_Type)
);


DROP TABLE IF EXISTS  zona;
CREATE TABLE IF NOT EXISTS zona ( #tabla 6
    IdZona     INT NOT NULL AUTO_INCREMENT,
	IdBorough INTEGER, 
    Zone varchar(50), 
    service_zone varchar(50),
    PRIMARY KEY (IdZona),
    FOREIGN KEY (IdBorough) REFERENCES borough(IdBorough)
);


### SE CREA LA TABLA TAXIS_AUX

DROP TABLE IF EXISTS  taxis_aux;
CREATE TABLE IF NOT EXISTS taxis_Aux (
	
    IdVendor INTEGER,#1
    tpep_pickup_datetime  datetime, #2
    tpep_dropoff_datetime datetime, #3
    passenger_count  INTEGER, #4
    trip_distance double, #5
    IdRateCode INTEGER, #6
    IdPayment_Type INTEGER,#7
    fare_amount double,#8
    extra    double,#9
    mta_tax    double,#10
    tip_amount double,#11
    tolls_amount    double,#12
    improvement_surcharge   double,#13
    total_amount   double,#14
    IdSemana INTEGER,
    IdFecha INTEGER,#15
    IdPUborough INTEGER,#16
    IdDOborough INTEGER,#17
    outlier INTEGER#18
    
    )  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
    
    
#CREO LA TABLA
 DROP TABLE IF EXISTS  clima_aux;
create table if not exists clima_aux (

        hora datetime,
        temp float, 
        feelslike  double, 
        precip  float, 
        snow float, 
        snowdepth float, 
        IdCondiciones integer,
        IdFecha integer
        
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
    
#SE CREA LA TABLA clima 
CREATE TABLE clima LIKE clima_aux;
alter table clima add  column IdClima  int not null auto_increment key; #SE AGREGA LA PRIMARY KEY
#alter table clima add primary KEY (IdFecha);
alter table clima add FOREIGN KEY (IdCondiciones) REFERENCES clima_conditions(IdCondiciones);
#ALTER TABLE `clima` ADD INDEX(`IdFecha`);
#alter table clima add unique key IdFecha_idx (IdFecha);


    
    
    
    
    
    
    

    
    
    
    
    
 
#SE CREA LA TABLA TAXIS 
CREATE TABLE taxis LIKE taxis_aux;
alter table taxis add  column IdTaxi  int not null auto_increment key ;#SE AGREGA LA PRIMARY KEY

###  FOREIGNS ###
ALTER TABLE taxis add FOREIGN KEY (IdVendor) REFERENCES vendor(IdVendor); 

ALTER TABLE taxis add FOREIGN KEY (IdRateCode) REFERENCES RateCode(IdRateCode);

#ALTER TABLE taxis add FOREIGN KEY (IdPUborough) REFERENCES borough(IdBorough);
#ALTER TABLE taxis add FOREIGN KEY (IdDOborough) REFERENCES borough(IdBorough);
ALTER TABLE taxis add FOREIGN KEY (IdPayment_Type) REFERENCES payment_type(IdPayment_Type);


#ALTER TABLE taxis add FOREIGN KEY (IdFecha) REFERENCES clima(IdFecha);
#ALTER TABLE taxis add FOREIGN KEY (IdPUborough) REFERENCES borough(IdBorough);




#SE CREA EL PROCEDIMIENTO  taxi

DELIMITER $$

CREATE PROCEDURE traerUnicos()
BEGIN
	insert into taxis select   ta.* , null from taxis t right join  taxis_Aux ta
on 	
	t.tpep_pickup_datetime= ta.tpep_pickup_datetime and
	t.tpep_dropoff_datetime =ta.tpep_dropoff_datetime and
	t.passenger_count = ta.passenger_count and
	t.trip_distance = ta.trip_distance and 
    t.total_amount = ta.total_amount 


where t.IdVendor is null;

truncate table taxis_Aux;
    
END$$

DELIMITER ;

#use taxi_2;
#call traerUnicos();

#SE CREA EL PROCEDIMIENTO  taxi clima

DELIMITER $$

CREATE PROCEDURE traerUnicosClima()
BEGIN
	insert into clima select ca.* , null from clima c right join  clima_Aux ca
on 	c.hora= ca.hora and
	c.temp= ca.temp and
	c.feelslike =ca.feelslike and
	c.precip = ca.precip and
	c.snow = ca.snow and 
	c.snowdepth = ca.snowdepth and
    c.IdCondiciones = ca.IdCondiciones and 
    c.IdFecha = ca.IdFecha 
    
where c.hora is null;

truncate table clima_Aux;
    
END$$

DELIMITER ;        

use taxi_2;
select count(*) from taxis;

CREATE VIEW taxiV1 AS
select t.*, 
timestampdiff(minute, t.tpep_pickup_datetime,t.tpep_dropoff_datetime ) as duracion_de_viaje, 
hour(t.tpep_pickup_datetime) as hora_inicio_viaje  ,
DATE_FORMAT(t.tpep_pickup_datetime, "%Y-%m-%d %H:00:00") as hora_round,
DAYNAME(t.tpep_pickup_datetime) as Nombre_del_dia
from taxis t;

