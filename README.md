# alert-Manager-Prometheus


Ports:

prometheus Port :9090
alertManager Port: 9093

clone above file and run the script. it will install alertmanager agent on your Amazon Linux2 server please use root user for success installation.


it will create a sample alert rule in rules.yml file. please edit the file to change the alert rules.


to connect with Gmail or Slack:

to connect with Gmail, add below commands to /etc/alertmanager/alertmanager.yml file under reciver:

- name: 'gmail'
  email_configs:
  - to: '<google-username>@gmail.com'
    from: '<google-username>@gmail.com'
    smarthost: smtp.gmail.com:587
    auth_username: '<google-username>@gmail.com'
    auth_identity: '<google-username>@gmail.com'
    auth_password: '<google-app-password>'
    
    replace the <google-username> with prefix of email.
    also replace <google-app-password> with the creds created from google account.
  
  
 it will be like this:
<img width="856" alt="image" src="https://user-images.githubusercontent.com/74951749/202229234-fc52ae0c-71ac-46be-a1fa-ba3b78d853f5.png">




    
    
    
