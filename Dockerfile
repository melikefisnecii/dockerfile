FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

COPY . .

RUN dotnet restore

RUN apt-get update && apt-get install -y libgdiplus libc6-dev

RUN dotnet publish -c Release -o /app /p:TreatWarningsAsErrors=false

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

COPY --from=build /app .

ENTRYPOINT ["dotnet", "EkampusCore.WebSites.RaporAl.dll"]
