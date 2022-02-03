from mysql.connector import connect, Error
import mysql.connector
from colorama import Fore, Back

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="db_project"
)

cursor = mydb.cursor()

show_main_menu = True
sign_up_successfully = False
doctor_sign_up_successfully = False
nurse_sign_up_successfully = False
log_in_successfully = False
create_new_brand_successfully = False
create_new_vaccination_center_successfully = False

def print_first_menu():
    print("Please Choose\n1)Sign up \n2)Log in")


def print_general_menu():
    print("Select the operation you want:\na)View profile\nb)Change password\nc)Rate\nd)Show vaccination center "
          "ratings\ne)Show daily injections\nf)Vaccinated number of each brand and total vaccinated number\ng)Show "
          "the rate of vaccination center of each brand\nh)Rate of proper centers\ni)HOME PAGE")


print("Welcome to Vaccination Center.")


while True:
    print_first_menu()
    show_main_menu = True
    sign_up_successfully = False
    doctor_sign_up_successfully = False
    nurse_sign_up_successfully = False
    log_in_successfully = False
    create_new_brand_successfully = False
    create_new_vaccination_center_successfully = False
    enter = int(input())
    if enter == 1:  # user wants to sign up
        while not sign_up_successfully:
            print("Please enter your specifications: ")
            user_national_id = input(">>National ID (Must be 10 digits): ")
            user_password = input(">>Password (Must contain number and letter more than 8): ")
            user_name = input(">>Name:")
            user_family_name = input(">>Family name: ")
            user_gender = input("Gender: Female/Male ")
            if user_gender == 'F':
                user_gender = 'female'
            elif user_gender == 'M':
                user_gender = 'male'
            user_birthday = input(">>Birthday (In the form of yy-mm-dd): ")
            user_special_disease = input(">>Do you have any special disease? y/n ")
            if user_special_disease == 'n':
                user_special_disease = 'no'
            if user_special_disease == 'y':
                user_special_disease = 'yes'
            my_input = [user_national_id, user_password, user_name, user_family_name, user_gender, user_birthday, user_special_disease]
            try:
                cursor.callproc('sign_up', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
                if res == "sign up successful":
                    sign_up_successfully = True

        user_is_medico = input(">>Are you a Doctor or Nurse? D/N/none ")
        if user_is_medico == 'D':
            while not doctor_sign_up_successfully:
                user_medical_id = input(">>Enter your medical code: (Must be 5 digits) ")
                my_input = [user_national_id, user_medical_id]
                try:
                    cursor.callproc('add_doctor', my_input)
                except Exception as e:
                    res = str(e)[14:]
                    print(Fore.RED + res + Fore.RESET)
                    if res == 'doctor added successfully':
                        doctor_sign_up_successfully = True

        if user_is_medico == 'N':
            while not nurse_sign_up_successfully:
                user_degree = input(">>Enter your nursing degree: 'Matron', 'Supervisor', 'Nurse', 'Practical' (just "
                                    "first letter)")
                if user_degree == 'M':
                    user_degree = 'matron'
                if user_degree == 'S':
                    user_degree = 'supervisor'
                if user_degree == 'N':
                    user_degree = 'nurse'
                if user_degree == 'P':
                    user_degree = 'practical'
                user_nursing_id = input(">>Enter your nursing code: (Must be 8 digits)")
                my_input = [user_national_id, user_degree, user_nursing_id]
                try:
                    cursor.callproc('add_nurse', my_input)
                except Exception as e:
                    res = str(e)[14:]
                    print(Fore.RED + res + Fore.RESET)
                    if res == 'nurse added successfully':
                        nurse_sign_up_successfully = True
        # distinguish role
        user_mode = "custom"
        if user_is_medico == 'D':
            user_mode = "doctor"
        elif user_is_medico == 'N':
            user_mode = "nurse"

    if enter == 2:  # user wants to log in
        while not log_in_successfully:
            user_national_id = input(">>National ID (Must be 10 digits): ")
            user_password = input(">>Password (Must contain number and letter more than 8): ")
            foo = None
            my_input = [user_national_id, user_password, foo]

            try:
                res = cursor.callproc('log_in', (user_national_id, user_password, foo))

            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
                if res == "log in successful":
                    log_in_successfully = True
                    user_type = ""
                    my_input = [user_national_id, user_type]
                    res = cursor.callproc('find_user_type', my_input)
                    user_mode = res[-1]
        if user_mode == 'doctor':
            my_input = [user_national_id, '']
            res = cursor.callproc('get_doctor_medical_id', my_input)
            user_medical_id = res[-1]
        if user_mode == 'nurse':
            my_input = [user_national_id, '']
            res = cursor.callproc('get_nurse_nursing_id', my_input)
            user_nursing_id = res[-1]
            my_input = [user_nursing_id, '']
            res = cursor.callproc('get_nurse_degree', my_input)
            user_degree = res[-1]

    while show_main_menu:
        # general menu
        print_general_menu()
        if user_mode == "doctor":
            print("Select DOCTOR operation you want:\n1.1)Create new brand\n1.2)Create new vaccination "
                  "center\n1.3)Delete an account")
        if user_mode == "nurse":
            print("Select NURSE operation you want:\n2.1)Create new vaccine(Only matrons)\n2.2)Record an injection")

        user_operation = input()

        if user_mode == "doctor" and user_operation == '1.1':  # doctor operations
            print("You are creating new brand...")
            new_brand_name = input("Enter name: ")
            new_brand_dose = input("Enter dose: ")
            new_brand_intervals = input("Enter interval days: ")
            my_input = [new_brand_name, new_brand_dose, new_brand_intervals, user_medical_id]
            try:
                cursor.callproc('create_new_brand', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
                if res == 'new brand added':
                    create_new_brand_successfully = True

        elif user_mode == "doctor" and user_operation == '1.2':
            print("You are creating new vaccination center...")
            new_center_name = input("Enter name: ")
            new_center_street = input("Enter address, street: ")
            new_center_plaque = input("Enter address, plaque: ")
            my_input = [new_center_name, new_center_street, new_center_plaque]
            try:
                cursor.callproc('create_new_vaccination_center', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
                if res == 'new vaccination center added':
                    create_new_vaccination_center_successfully = True

        elif user_mode == "doctor" and user_operation == '1.3':
            print("You are deleting an account...")
            account_national_id_to_delete = input("Enter the national ID of the account you want to delete: ")
            my_input = [account_national_id_to_delete]
            try:
                cursor.callproc('delete_account', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)

        elif user_mode == "nurse" and user_operation == '2.1':  # nurse operations
            print("You are adding new vaccine vial...")
            new_vaccine_serial_number = input("Enter serial number (12 digits): ")
            new_vaccine_brand = input("Enter brand name: ")
            new_vaccine_production_date = input("Enter production date: ")
            new_vaccine_dose = input("Enter dose: ")
            my_input = [user_nursing_id, new_vaccine_serial_number, new_vaccine_brand, new_vaccine_production_date, new_vaccine_dose]
            try:
                cursor.callproc('create_new_vaccine', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
        elif user_mode == "nurse" and user_operation == '2.2':
            print("You are submitting an injection...")
            injection_national_id = input("Enter national ID of vaccinated person: ")
            injection_vaccination_center = input("Enter the vaccination center name: ")
            injection_serial_number = input("Enter the serial number of the vaccine: ")
            injection_nursing_id = user_nursing_id
            my_input = [injection_national_id, injection_vaccination_center, injection_serial_number, injection_nursing_id]
            try:
                cursor.callproc('create_new_injection', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
        if user_operation == 'a':  # visit profile
            my_input = [user_national_id]
            cursor.callproc('visit_profile', my_input)
            for result in cursor.stored_results():
                res = result.fetchone()
                print(Fore.GREEN)
                print("|ID :", res[0], "|account creation date", res[2], "|name :", res[3], "|family name :", res[4], "|gender :", res[5], "|birthday :", res[6], "|special disease :", res[7])
                print(Fore.RESET)

        if user_operation == 'b':  # change password
            user_new_password = input("Enter new password (Must contain number and letter more than 8): ")
            my_input = [user_national_id, user_new_password]
            try:
                cursor.callproc('change_password', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
        if user_operation == 'c':  # rating a center
            score_center_name = input("Enter the vaccination center name: ")
            score_score = input("Enter the rate (must be a number 1-5): ")
            my_input = [user_national_id, score_center_name, score_score]
            try:
                cursor.callproc('score', my_input)
            except Exception as e:
                res = str(e)[14:]
                print(Fore.RED + res + Fore.RESET)
        if user_operation == 'd':  # view all centers average score
            cursor.callproc('show_center_scores')
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                print(Fore.MAGENTA, item[0], ":", item[1], Fore.RESET)
        if user_operation == 'e':  # view daily vaccinations
            cursor.callproc('show_daily_vaccinations')
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                print(Fore.YELLOW, item[1], ":", item[0], Fore.RESET)
        if user_operation == 'f': # vaccinated number of each brand
            cursor.callproc('brand_vaccinated_number')
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                print(Fore.BLUE, item[0], ":", item[1], Fore.RESET)
            cursor.callproc('get_total_vaccinated')
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                print(Fore.BLUE, "total :", item[0], Fore.RESET)
        if user_operation == 'g':  # rate of each brand in each center
            cursor.callproc('show_brand_center_score')
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                print(Fore.MAGENTA, item[0], "|", item[1], "|", item[2], Fore.RESET)
        if user_operation == 'h':  # get proper centers
            my_input = [user_national_id]
            cursor.callproc('get_brand_name', my_input)
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                user_vaccine_brand_name = item[0]
            my_input = [user_vaccine_brand_name]
            cursor.callproc('get_proper_centers', my_input)
            for result in cursor.stored_results():
                res = result.fetchall()
            for item in res:
                print(Fore.LIGHTBLUE_EX, item[0], ":", item[1], Fore.RESET)
        if user_operation == 'i':
            show_main_menu = False

