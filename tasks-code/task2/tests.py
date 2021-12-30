from re import S
import unittest
import examinee

# # test valid email
# 1. ab.de@gmx.de
# 2. ab+12@gmx.de
# 3. "abc@gmx.de"@gmx.de <- According to RFC 5322, this is a valid email address, but the code above would not accept it

# # test invalid email
# 1. ab.13.@gmx.de
# 2. sd@gmx.
# 3. ab@ab@gmx.de

class EmailTest(unittest.TestCase):
    def test_valid_email(self):
        examinee.validate_email('abc@gmx.de')

    def test_valid_email_with_plus(self):
        examinee.validate_email('abc+f@gmx.de')

    def test_invalid_email(self):
        with self.assertRaises(examinee.EmailNotValidError):
            examinee.validate_email('aadadd')

    @unittest.skip('should be valid')
    def test_valid_email_with_quotes(self):
        examinee.validate_email('"abc@gmx.de"@gmx.de')


### ...

# co pilot not really able to support the development of this task
