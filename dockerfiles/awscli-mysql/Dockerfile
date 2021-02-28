FROM mysql:8.0.23
RUN apt-get update && apt-get install -y python3 curl unzip vim
RUN sed -i '1s/^/openssl_conf = default_conf\n/' /usr/lib/ssl/openssl.cnf
RUN echo "[ default_conf ] \n\
ssl_conf = ssl_sect\n\
[ssl_sect]\n\
system_default = ssl_default_sect\n\
[ssl_default_sect]\n\
MinProtocol = TLSv1\n\
CipherString = DEFAULT:@SECLEVEL=1" >> /usr/lib/ssl/openssl.cnf 
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN echo "export LANG=en_US.UTF-8" >> /root/.bashrc
CMD ["/bin/bash"]