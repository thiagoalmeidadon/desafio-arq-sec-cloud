FROM python:3.11-slim
WORKDIR /app
COPY hello.py .
RUN pip install flask gunicorn
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:80", "hello:app"]