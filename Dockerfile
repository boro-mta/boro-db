# Use the official Microsoft SQL Server image as the base image
FROM mcr.microsoft.com/mssql/server:2019-latest

# Set environment variables for SQL Server configuration
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Passw0rd1

# Copy your database scripts to the container
COPY ./scripts /scripts

# Run your database scripts when the container starts
CMD /bin/bash /scripts/startup.sh
