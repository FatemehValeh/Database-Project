create table person(
    national_id char(10) primary key unique,
    password varchar(512),
    creation_date timestamp,
    name varchar(512),
    family_name varchar(512),
    gender varchar(6) check ( gender in ('female', 'male')),
    birthday date,
    special_disease varchar(3) check ( special_disease in ('yes', 'no') )
);
create table doctor(
    national_id char(10) primary key ,
    medical_id char(5) unique ,
    foreign key (national_id) references person(national_id) on delete cascade on update cascade
);

create table nurse(
    national_id char(10),
    degree varchar(10),
    nursing_id char(8) ,
    primary key (nursing_id, national_id),
    foreign key (national_id) references person(national_id) on delete cascade on update cascade
);

drop table nurse;

create table logged_report(
     national_id char(10),
     foreign key (national_id) references person(national_id),
     tag varchar(512) primary key ,
     login_time timestamp
);

create table brand(
    name varchar(512) unique primary key,
    dose int,
    interval_days int,
    doctor_medical_id char(5),
    foreign key (doctor_medical_id) references doctor(medical_id)
);

create table vaccination_center(
    name varchar(512) unique primary key,
    street varchar(512),
    plaque varchar(512)
);

create table center_brand(
    center_name varchar(512) primary key ,
    foreign key (center_name) references vaccination_center(name),
    brand_name varchar(512) primary key ,
    foreign key (brand_name) references brand(name)
);

create table vaccine(
    serial_number char(12) unique primary key,
    brand_name varchar(512),
    foreign key (brand_name) references brand(name),
    production_date date,
    dose int
);

create table injection(
    national_id char(10),
    foreign key (national_id) references person(national_id),
    vaccination_center varchar(512),
    foreign key (vaccination_center) references vaccination_center(name),
    vaccine_serial_number char(12),
    foreign key (vaccine_serial_number) references vaccine(serial_number),
    date date,
    nursing_id  char(8) ,
    foreign key (nursing_id) references nurse(nursing_id),
    primary key (national_id, vaccine_serial_number, date)
);
drop table injection;

create table score(
    national_id char(10),
    foreign key (national_id) references person(national_id),
    vaccination_center varchar(512),
    foreign key (vaccination_center) references vaccination_center(name),
    rate int,
    primary key (national_id, vaccination_center)
);



