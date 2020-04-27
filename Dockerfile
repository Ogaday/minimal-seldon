FROM continuumio/miniconda3

WORKDIR /app
COPY env.yaml IdentityModel.py /app/
RUN conda env update -f env.yaml

EXPOSE 5000

# Define environment variable
ENV MODEL_NAME IdentityModel
ENV API_TYPE REST
ENV SERVICE_TYPE MODEL
ENV PERSISTENCE 0

CMD exec seldon-core-microservice $MODEL_NAME $API_TYPE --service-type $SERVICE_TYPE --persistence $PERSISTENCE
