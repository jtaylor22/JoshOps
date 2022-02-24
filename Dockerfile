FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && \
 apt-get -y install apache2

# Configure apache
RUN echo '. /etc/apache2/envvars' > /root/run_apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run_apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run_apache.sh && \ 
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run_apache.sh && \ 
 chmod 755 /root/run_apache.sh

EXPOSE 80
CMD /root/run_apache.sh

RUN echo "<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #1234;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App V2</h1> <h2>Congratulations, app is now V2!!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>" > /var/www/html/index.html
