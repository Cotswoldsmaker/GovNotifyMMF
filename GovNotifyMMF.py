# -*- coding: utf-8 -*-
"""
Created on Thu Mar 18 07:02:31 2021

@author: mark.bailey
"""

import sys
import threading
import mmap
import time as t
from notifications_python_client.notifications import NotificationsAPIClient

singleRun = True
SEPARATOR = "|"
SEPARATOR_SUB = ";"
response = ''
sleepTime = 1



def GOV_UK_notify(arguments):
    argSplit = arguments.split(SEPARATOR_SUB)
    method = argSplit[0]
    api_key = argSplit[1]
    template_ID = argSplit[2]
    
    
    try:
        if method == 'SMS':
            notifications_client = NotificationsAPIClient(api_key)  # API_key from GOV.uk Notify
            
            response = notifications_client.send_sms_notification(
                template_id= template_ID,                               # This is the SMS template ID on GOV.uk Notify
                phone_number= argSplit[3],                             # Mobile number in format 01234 567890
            
                personalisation={
                    'message': argSplit[4],                             # The message to send via SMS
                }
            )
                
        elif method == 'email':
            notifications_client = NotificationsAPIClient(api_key)  # API_key from GOV.uk Notify
            
            response = notifications_client.send_email_notification(
                template_id= template_ID,                               # This is the email template ID on GOV.uk Notify
                email_address= argSplit[3],                             # email address
                
                personalisation={
                    'subject': argSplit[4],
                    'message': argSplit[5],
                }
            )
            
        elif method == 'letter':
            notifications_client = NotificationsAPIClient(api_key)  # API_key from GOV.uk Notify
            
            addressLines = argSplit[3].split("//")
            
            personalisationT={               
                'from' : argSplit[4],
                'heading' : argSplit[5],
                'body' : argSplit[6],
            }
            
            for index, line in enumerate(addressLines):
                lineNr = index + 1
                personalisationT['address_line_' + str(lineNr)] = line
           
            response = notifications_client.send_letter_notification(template_id=template_ID, personalisation = personalisationT)
        else:
            return "wrong method"
    except:
        return "fail"
    else:
        return "pass - %s" %(response)
    return "error"




def sleepTimeF(argument):
    global sleepTime
    
    sleepTime = int(argument)
    #print('Sleep timer set to: %s' %(argument))
    return ' '





class MemoryMappedFile_IPC:
    def __init__(self, MMFName):
        self.MMFName = MMFName
        self.MMFInstance = mmap.mmap(0, 1000000, self.MMFName, mmap.ACCESS_WRITE)
    
    def read(self):
        self.MMFInstance.seek(0) #Move back to beginning of file
        received = str(self.MMFInstance.read())
        if received.find("<") == 2:
            endMarker = received.find(">")
            if endMarker != -1:
                return received[3:endMarker]
        else:
            return -1
                
    def write(self, func, argument = ""):
        global SEPARATOR
        
        func = func.replace("<", "")
        func = func.replace(">", "")
        func = func.replace("|", "")

        argument = argument.replace("<", "less than")
        argument = argument.replace(">", "more than")
        argument = argument.replace("|", "pipe")
        
        if argument == "":
            buffer = "<" + func + ">"
        else:
            buffer = "<" + func + SEPARATOR + argument + ">"
        
        self.MMFInstance.seek(0) #Move back to beginning of file
        self.MMFInstance.write(bytes(buffer, 'UTF-8'))



class mainClass(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
    def run(self):
        mainThread()    
    
    
def mainThread():
    global SEPARATOR, count_vect, clf, pythonFolder
    
    AHK_Messages =  MemoryMappedFile_IPC("AHK_2_Python_IPC")    
    
    while True:
        MMFRead = AHK_Messages.read()

        try:
            MMFSplit = MMFRead.split(SEPARATOR)
            functionCall = MMFSplit[0]
            # Cannot assign MMFSplit[1] here as causes issues, done later!
        except:
            None
        else:
            if "close" in functionCall:
                AHK_Messages.write("SPRead")
                break
        
            elif functionCall != "SPRead" and functionCall != "wait":
                HandleError = False # Helps to show up errors with the dispacher function calls
                argument = MMFSplit[1]
                dispatcher = {'GOV_UK_notify' : GOV_UK_notify, 'sleepTimeF' : sleepTimeF}
                
                if functionCall in dispatcher:
                    if HandleError == True:
                        try:
                            returnResult = dispatcher[functionCall](argument)
                        except:
                            AHK_Messages.write("SPRead", 'error')
                        else:
                            AHK_Messages.write("SPRead", returnResult)
                    else:
                        returnResult = dispatcher[functionCall](argument)
                        AHK_Messages.write("SPRead", returnResult)
                else:
                    errorMessage = 'Function name \'%s\' was not found in python script' %(functionCall)
                    AHK_Messages.write("SPRead", errorMessage)
                
                if singleRun:
                    break
        
        if singleRun:         
            t.sleep(0.1)
        else:
            t.sleep(sleepTime)
            
    sys.exit()
 
    

if __name__ == '__main__':
    main = mainClass()
    main.start()