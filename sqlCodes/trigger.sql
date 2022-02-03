
create trigger check_signup_information before insert on person
for each row
    begin
        if length(new.national_id) <> 10 then
        signal sqlstate '45000' set message_text = 'national ID must be 10 digits';
        end if;
        if NEW.national_id regexp '[A-Za-z]' then
        signal sqlstate '45000' set message_text = 'national ID must contains only digits';
        end if;
        if NEW.national_id in (select national_id from person) then
        signal sqlstate '45000' set message_text = 'A user with similar ID exists';
        end if;
        if length(NEW.password) < 8 then
        signal sqlstate '45000' set message_text = 'password at lest must be 8 characters';
        end if;
        if NEW.password not regexp '[0-9]' or NEW.password not regexp '[a-z]'or NEW.password not regexp '[A-Z]' then
        signal sqlstate '45000' set message_text = 'password must contain at least one digit and one letter';
        else
            set NEW.password = md5(NEW.password);
        end if;
    end;

create trigger check_doctor_information before insert on doctor
    for each row
    begin
    if length(NEW.medical_id) <> 5 then
    signal sqlstate '45000' set message_text = 'medical code must be 5 digits';
    end if;
    if NEW.medical_id regexp '[A-Za-z]' then
    signal sqlstate '45000' set message_text = 'medical code must contains only digits';
    end if;
    if NEW.medical_id in (select medical_id from doctor) then
    signal sqlstate '45000' set message_text = 'medical ID already exists';
    end if;
    if NEW.national_id not in (select national_id from person) then
        signal sqlstate '45000' set message_text = 'this national id doesn\'t exists in system';
    end if;
    end;

create trigger check_nurse_information before insert on nurse
    for each row
    begin
        if NEW.degree not in ('matron', 'supervisor', 'nurse', 'practical') then
            signal sqlstate '45000' set message_text = 'nurse degree is illegal';
        end if;
        if length(NEW.nursing_id) <> 8 then
            signal sqlstate '45000' set message_text = 'nursing code must be 8 digits';
        end if;
        if NEW.nursing_id regexp '[A-Za-z]' then
            signal sqlstate '45000' set message_text = 'nursing code must contains only digits';
        end if;
        if NEW.nursing_id in (select nursing_id from nurse) then
            signal sqlstate '45000' set message_text = 'nursing ID already exits';
        end if;
        if NEW.national_id not in (select national_id from person) then
            signal sqlstate '45000' set message_text = 'this national id doesn\'t exists in system';
        end if;
    end;

create trigger check_login_information;

create trigger check_new_brand before insert on brand
    for each row
    begin
    if new.name in (select name from brand) then
        signal sqlstate '45000' set message_text = 'brand already exist';
    end if;
    if NEW.doctor_medical_id not in (select medical_id from doctor) then
        signal sqlstate '45000' set message_text = 'only doctors can add new brands';
    end if;
    end;

create trigger check_new_center before insert on vaccination_center
    for each row
    begin
        if new.name in (select name from vaccination_center) then
        signal sqlstate '45000' set message_text = 'vaccination center already exists';
    end if;
    end;

create trigger check_new_vaccine before insert on vaccine
    for each row
    begin
        if NEW.serial_number in (select serial_number from vaccine) then
            signal sqlstate '45000' set message_text = 'vaccine with same serial number already exists';
        end if;
        if NEW.brand_name not in (select name from brand) then
            signal sqlstate '45000' set message_text = 'new vaccine brand name doesn\'t exists';
        end if;
    end;

create trigger check_new_injection before insert on injection
    for each row
    begin
        if NEW.national_id in (select national_id from injection as i where i.vaccine_serial_number = NEW.vaccine_serial_number and i.date = NEW.date) then
            signal sqlstate '45000' set message_text = 'this injection record already exits';
        end if;
        if NEW.national_id not in (select national_id from person) then
            signal sqlstate '45000' set message_text = 'person doesn\'t exist in system';
        end if;
        if NEW.vaccination_center not in (select name from vaccination_center) then
            signal sqlstate '45000' set message_text = 'vaccination center name doesn\'t exist in system';
        end if;
        if NEW.vaccine_serial_number not in (select serial_number from vaccine) then
            signal sqlstate '45000' set message_text = 'vaccine serial number doesn\'t exist in system';
        end if;
        if NEW.nursing_id not in (select nursing_id from nurse) then
            signal sqlstate '45000' set message_text = 'only nurses can add new injections';
        else
            set NEW.date = current_timestamp();
        end if;
    end;
drop trigger check_new_injection;
create trigger check_new_password before update on person
    for each row
    begin
        if length(NEW.password) < 8 then
        signal sqlstate '45000' set message_text = 'password at lest must be 8 characters';
        end if;
        if NEW.password not regexp '[0-9]' or NEW.password not regexp '[a-z]'or NEW.password not regexp '[A-Z]' then
        signal sqlstate '45000' set message_text = 'password must contain at least one digit and one letter';
        else
            set NEW.password = md5(NEW.password);
        end if;
    end;

create trigger check_rate before insert on score
    for each row
    begin
        if NEW.rate < 1 or NEW.rate > 5 then
            signal sqlstate '45000' set message_text = 'rate must be between 1 to 5 ';
        end if;
        if NEW.national_id not in (select national_id from injection as i where i.vaccination_center = NEW.vaccination_center) then
            signal sqlstate '45000' set message_text = 'you can just rate a center you had injection in';
        end if;
        if NEW.national_id in (select national_id from score) then
            signal sqlstate '45000' set message_text = 'you have already scored this center';
        end if;
    end;

drop trigger check_rate;

