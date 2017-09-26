FROM python:2.7-alpine3.6

ADD . /app
WORKDIR /app
RUN pip install -r requirements.txt
CMD ["python", "app.py"]    
EXPOSE 80