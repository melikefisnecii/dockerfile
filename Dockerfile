FROM mcr.microsoft.com/dotnet/sdk:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build 
ARG BUILD_CONFIGURATION=Release(???) 
WORKDIR /src
COPY ['' EKampusCore.WebSites.RaporAl.csproj''] 
RUN dotnet restore '' EKampusCore.WebSites.RaporAl '' 
COPY . . 
WORKDIR ''/src/''
RUN dotnet build ''EKampusCore.WebSites.RaporAl.csproj'' -c $BUILD_CONFIGURATION -o /app/build 

FROM build AS publish 
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish ''EKampusCore.WebSites.RaporAl.csproj'' -c $BUILD_CONFIGURATION -O /app/publish /p:UseAppHost=false

FROM base AS final 
WORKDIR /app
COPY --from=publish /app/publish . 
ENTRYPOINT [''dotnet'', ''EKampus.RaporAl.Core.dll'']

