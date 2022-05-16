#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Examples.WebService/Examples.WebService.csproj", "Examples.WebService/"]
RUN dotnet restore "Examples.WebService/Examples.WebService.csproj"
COPY . .
WORKDIR "/src/Examples.WebService"
RUN dotnet build "Examples.WebService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Examples.WebService.csproj" -c Release -o /app/publish	

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Examples.WebService.dll"]