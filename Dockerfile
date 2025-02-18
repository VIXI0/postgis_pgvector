# Use the PostGIS image as the base
FROM postgis/postgis:17-3.5

# Update package list and install necessary packages in a single RUN command to reduce layers
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends wget git build-essential libpq-dev postgresql-server-dev-17 && \
    rm -rf /var/lib/apt/lists/*

# Clone the pgvector repository and build/install in a single RUN command
RUN git clone --branch v0.8.0 https://github.com/pgvector/pgvector.git /tmp/pgvector && \
    cd /tmp/pgvector && make && make install && \
    rm -rf /tmp/pgvector

# Clean up unnecessary packages
RUN apt-get purge -y --auto-remove wget git build-essential libpq-dev

# Copy initialization scripts
COPY ./docker-entrypoint-initdb.d/ /docker-entrypoint-initdb.d/
