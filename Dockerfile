# Use the official .NET Core SDK as the base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

# Set the working directory inside the container
WORKDIR /app

# Copy the .NET project files and restore dependencies
COPY ./src/*.csproj ./
RUN dotnet restore

# Copy the rest of the application source code
COPY . ./src/

# Build the .NET application
RUN dotnet publish -c Release -o out

# Use a smaller runtime image for the final image
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Set the working directory inside the container
WORKDIR /app

# Copy the published output from the build environment
COPY --from=build-env /app/out .

# Define the command to run your .NET application
CMD ["dotnet", "SimpleDotNetApp.dll"]
