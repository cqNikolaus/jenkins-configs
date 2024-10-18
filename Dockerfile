FROM python

RUN apt-get update && \
    apt-get install -y --no-install-recommends dnsutils openssl git && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR /code


RUN git init && \
    git remote add origin https://github.com/cqNikolaus/jenkins_automation.git && \
    git config core.sparseCheckout true && \
    echo "requirements.txt" >> .git/info/sparse-checkout && \
    git pull origin main


RUN pip install --no-cache-dir --upgrade -r requirements.txt

