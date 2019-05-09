import unittest
import os
from random import randint
from appium import webdriver
from time import sleep
from selenium.webdriver.common.keys import Keys

class AuthTests(unittest.TestCase):
    def setUp(self):
        app = ('./Point.app')
        self.driver = webdriver.Remote(
            command_executor='http://127.0.0.1:4723/wd/hub',
            desired_capabilities={
                'app': app,
                'platformName': 'iOS',
                'platformVersion': '11.4',
                'deviceName': 'iPhone 6s'
            }
        )
    
    def testPhoneTextField(self):
        phoneTextField = self.driver.find_element_by_accessibility_id('phoneTextField')
        phoneTextField.send_keys("+79264931002")
        sleep(1)
        self.assertEqual(phoneTextField.get_attribute("value"), "+7 926 493-10-02")

    def testPasswordField(self):
        passwordTF = self.driver.find_element_by_accessibility_id('passwordTextField')
        passwordTF.send_keys("validPW")
        passwordTF.send_keys(Keys.RETURN)
        sleep(1)
        self.assertNotEqual(passwordTF.get_attribute("value"), "validPW")
    
    def testLogin(self):
        self.testEmailField()
        self.testPasswordField()
        self.driver.find_element_by_accessibility_id('loginButton').click()
        sleep(1)
        smiley = self.driver.find_element_by_accessibility_id('smileyImage')
        self.assertTrue(smiley.get_attribute('wdVisible'))

    def tearDown(self):
        self.driver.quit()


if __name__ == '__main__':
        suite = unittest.TestLoader().loadTestsFromTestCase(AuthTests)
        unittest.TextTestRunner(verbosity=2).run(suite)