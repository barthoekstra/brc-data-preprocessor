FROM public.ecr.aws/lambda/python:3.10

COPY requirements.txt fetcher.py preprocessor.py ${LAMBDA_TASK_ROOT}

RUN pip3 install -r requirements.txt

CMD [ "fetcher.main" ]
