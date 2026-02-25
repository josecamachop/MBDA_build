# syntax=docker/dockerfile:1

# Start from jupiterhub/jupiterhub
FROM jupyterhub/jupyterhub:5.0.0

# Udpated/install packages
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install npm nodejs python3 python3-pip git nano octave nfdump -y

RUN python3 -m pip install jupyterhub notebook jupyterlab octave-kernel jupyterhub-nativeauthenticator dockerspawner jupyterhub-idle-culler

# Install the FCParser and dependencies
WORKDIR /
RUN git clone https://github.com/josecamachop/FCParser
RUN python3 -m pip install IPy PyYAML

# Install the MEDA Toolbox and dependencies
RUN git clone https://github.com/josecamachop/MEDA-Toolbox --branch v1.3 
RUN apt-get install octave-statistics -y

# Configure jupyterhub
RUN mkdir /etc/jupyterhub  
WORKDIR /etc/jupyterhub

# Change this with your certificate files (or see modification of the last line)  
# COPY ssl/key.pem . 
# COPY ssl/cert.pem . 

COPY home /home
RUN ln -s /home/jupyterhub_config.py jupyterhub_config.py 

# Ready to go: change to last line if no certificate is used
SHELL ["/bin/sh", "-c"]
ENTRYPOINT ["jupyterhub", "-f", "/etc/jupyterhub/jupyterhub_config.py", "--ssl-key", "/etc/jupyterhub/key.pem", "--ssl-cert", "/etc/jupyterhub/cert.pem"]
#ENTRYPOINT ["jupyterhub", "-f", "/etc/jupyterhub/jupyterhub_config.py"]
