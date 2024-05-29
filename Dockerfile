# Use the official .NET Core SDK as the base image from dev
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory inside the container
WORKDIR /app

# Copy the .NET project files and restore dependencies
COPY ./src/*.csproj ./
RUN dotnet restore

# Copy the rest of the application source code
COPY . .

# Build the .NET application
RUN dotnet publish -c Release -o out

# Use a smaller runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory inside the container
WORKDIR /app

# Copy the published output from the build environment
COPY --from=build-env /app/out .

# Expose port 80 to access the application
EXPOSE 80

# Define the command to run your .NET application
CMD ["dotnet", "SimpleWebApp.dll"]
