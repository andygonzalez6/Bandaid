import re

def is_valid_email(email):
    # Define a regex pattern for a basic email address validation
    pattern = r"^\S+@\S+\.\S+$" 

    # Use re.match to see if the string matches the pattern
    if re.match(pattern, email):
        return True
    else:
        return False