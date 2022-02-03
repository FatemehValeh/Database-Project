create procedure sign_up(u_national_id char(10), u_password varchar(512), u_name varchar(512),
u_family_name varchar(512), u_gender varchar(6), u_birthday date, u_special_disease varchar(3))
begin
    start transaction ;
        insert into person(national_id, password, creation_date, name, family_name, gender, birthday, special_disease)
         values (u_national_id, u_password, current_timestamp, u_name, u_family_name, u_gender, u_birthday, u_special_disease);
    signal sqlstate '45000' set message_text = 'sign up successful';
    commit ;

end;
drop procedure sign_up;
create procedure log_in(u_national_id char(10), n_password varchar(512))
begin
    declare last_password varchar(512);
    if u_national_id not in (select national_id from person) then
        signal sqlstate '45000' set message_text = 'you don\'t have account';
    end if;
    select password into last_password from person where national_id = u_national_id;
    if md5(n_password) != last_password then
        signal sqlstate '45000' set message_text = 'incorrect password';
    else
        insert into logged_report values (u_national_id, rand(), current_timestamp);
        signal sqlstate '45000' set message_text = 'log in successful';
    end if;
end;
call log_in('8888888888', '1234567j');
drop procedure log_in;

create procedure add_doctor(d_national_id char(10), d_medical_id char(5))
begin
    insert into doctor values (d_national_id, d_medical_id);
end;

create procedure add_nurse(n_national_id char(10), n_degree varchar(10), n_nursing_id char(8))
begin
    insert into nurse values (n_national_id, n_degree, n_nursing_id);
end;

create procedure create_new_brand(new_name varchar(512), new_dose int, new_interval_days int, new_medical_id char(5))
begin
    insert into brand(name, dose, interval_days, doctor_medical_id)
        values (new_name, new_dose, new_interval_days, new_medical_id);
    signal sqlstate '45000' set message_text = 'new brand added';
end;
call create_new_brand('Pfizer', 3, 60, '11111');


create procedure create_new_vaccination_center(new_name varchar(512), new_street varchar(512), new_plaque varchar(512))
begin
    insert into vaccination_center(name, street, plaque) values (new_name, new_street, new_plaque);
    signal sqlstate '45000' set message_text = 'new vaccination center added';
end;
call create_new_vaccination_center('06', 'Pasdaran', '128');
call create_new_vaccination_center('Azadi', 'Azadi', '200');
--
create procedure delete_account(u_national_id char(10))
begin
    delete from person where national_id = u_national_id;
end;
call delete_account('8888888888');
--
create procedure create_new_vaccine(n_serial_number char(12),n_brand_name varchar(512),n_production_date date, n_dose int)
begin
    insert into vaccine values (n_serial_number, n_brand_name, n_production_date, n_dose);
end;
call create_new_vaccine('123456789100', 'Pfizer', '2022-1-24', 3);
--
create procedure visit_profile(in u_national_id char(10))
begin
    select * from person where national_id = u_national_id;
end;
call visit_profile('0123456789');
--
drop procedure visit_profile;
create procedure create_new_injection(u_national_id char(10), n_vaccination_center varchar(512), n_vaccine_serial_number char(12), n_nursing_id  char(8))
begin
    insert into injection (national_id, vaccination_center, vaccine_serial_number, nursing_id) values (u_national_id, n_vaccination_center, n_vaccine_serial_number, n_nursing_id);
end;
call create_new_injection('0123456789', '06', '123456789123', '88888888');
call create_new_injection('9999999999', '06', '123456789123', '88888888');
call create_new_injection('8888888888', 'Azadi', '123456789123', '88888888');
delete
from injection
where national_id = '8888888888';
--

create procedure change_password(u_national_id char(10), new_password varchar(512))
begin
    update person set password = new_password where national_id = u_national_id;
end;
call change_password('8888888888', '1234567j');
--

create procedure score(u_national_id char(10), center_name varchar(512), u_rate int)
begin
    insert into score values (u_national_id, center_name, u_rate);
end;
call score('0123456789', '06', 5);
call score('9999999999', '06', 3);
call score('8888888888', 'Azadi', 1);
--
delete from score where rate=1;

create view center_scores as
    select vaccination_center, avg(rate) as avg_score
    from score
    group by vaccination_center
    order by avg_score desc
    limit 5;

create view daily_vaccinations as
    select count(national_id) as number, date
    from injection
    group by date
    order by date asc;

create view all_vaccinated as
    select count(distinct national_id) as number
    from injection;


# to do
create procedure brand_vaccinated_number()
begin
    declare dose_injected integer;
    declare count integer;
    select name from brand
    select national_id from injection as inj
    (
        select count(vaccine_serial_number) from injection as i where i.national_id =)
end;



select count (national_id) from injection as inj
(select dose from vaccine where inj.serial_number = vaccine.serial_number)
###



drop view center_scores;
call add_doctor('0123456768', '11111');
call sign_up('8888888888', 'mypass5678', 'ahmad', 'fekri', 'male', '1360-7-12', 'no');
call add_nurse('8888888888', 'supervisor', '88888888');
insert into injection (national_id, vaccination_center, vaccine_serial_number, date, nursing_id)
values ('0123456768', 'Azadi', '123456789100', '2022-1-25', '88888888');

create procedure foo(name varchar(512))
begin
    select dose from vaccine where brand_name = name;
end;
call foo('Pfizer');
drop procedure foo;