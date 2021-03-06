import json
import re
# imports were added afterwards

# reverse and convert a string to upper case
def reverse_and_upper(text):
    return text.upper()[::-1]
# instant recomendation from copilot


# load a json file into a dictionary
def load_json(filename):
    with open(filename) as f:
        return json.load(f)
# instant recomendation from copilot, but `import json` is missing

# check if a string is a valid email address
def is_email(text):
    return re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', text)
# instant recomendation from copilot, but `import re` is missing 
# the comment above, was generated by the copilot aswell
# appending `!= None` or `is not None ` to the end of the statemwent, would leed to a better solution
# abc+123@gmx.de is a valid email address according to > RFC 5322 section 3.4.1 <- (copilot autocompleted the RFC number)
# but the code above would not accept it
def is_email_rfc(text):
    local_part, domain_part = text.split('@')
    def is_atext(text):
        return re.match(r'^[\w\!\#\$\%\&\'\*\+\-\/\=\?\^\_\`\{\|\}\~]+(.*)$', text) # correct from copilot `(.*)` added by hand

    def is_dot_atom_text(text):
        atext_match = is_atext(text)
        if atext_match is None:
            return False
        while (text:= atext_match.group(1)) != '': # line written by hand
            if text[0] != '.':
                return False
            atext_match = is_atext(text[1:]) # generated by copilot
            if atext_match is None:
                return False

        return True
    
    def is_quoted_string(text):
        return re.match(r'^"(.*)"$', text) # from copilot, but incorrect because `"` is not a valid character in a quoted string
    
    if local_part == '' or domain_part == '':
        return False
    if is_dot_atom_text(local_part) == False:
        return False
    if is_dot_atom_text(domain_part) == False:
        return False
    return True
    # validation not complete!

# task to complex for case study

