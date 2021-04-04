# GovNotifyMMF
Python script to send REST API messages to GOV.uk Notify to send SMS message, emails and letters. Uses memory mapped files to communicate with other programs. Example code is with AutoHotKey control.

You need to sign up to GOV.uk first and then get an API-key and template ID. You need to create templates with the below 'personalisations'.

SMS:

mobile number in format 07123456789
message

Email:

email address
subject
message

letter:

address, using semi-colon ";" to denote new lines
from
heading
body

To make into an executable, make sure you have pyInstaller installed. Then go into the folder with your code and run:

pyinstaller --onefile .\GovNotifyMMF.py

The dist folder will then hold the exe

Exe has already been distributed on this repository in the AHK/Library folder. The Example1.ahk script has a GUI to allow you to send messages/letters. You just need to update the Private variables.ahk file with your API-key and template keys
