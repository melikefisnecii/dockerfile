FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 5040
EXPOSE 5030
EXPOSE 5200
EXPOSE 5061
EXPOSE 5001
EXPOSE 5100
EXPOSE 7058

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG buildConfiguration=Release
WORKDIR /src

RUN apt-get update && apt-get install -y libgdiplus libc6-dev && ln -s /usr/lib/libgdiplus.so /usr/lib/gdiplus.dll

COPY ["YourSolution.sln", "./"]
RUN dotnet restore "YourSolution.sln"

COPY . .

RUN dotnet build "EKampusCore.WebSites.RaporAl/EkampusCore.WebSites.RaporAl.csproj" -c $buildConfiguration -o /app/build/raporal
RUN dotnet build "Services/SystemManagement/EkampusCore.Services.SystemManagement.Api.csproj" -c $buildConfiguration -o /app/build/systemmanagement
RUN dotnet build "Services/Reports/EkampusCore.Services.Reports.Api.csproj" -c $buildConfiguration -o /app/build/reports
RUN dotnet build "Services/Login/EkampusCore.Services.Login.Api.csproj" -c $buildConfiguration -o /app/build/login

FROM build AS publish
ARG buildConfiguration=Release

RUN dotnet publish "EKampusCore.WebSites.RaporAl/EkampusCore.WebSites.RaporAl.csproj" -c $buildConfiguration -o /app/publish/raporal /p:UseAppHost=false /p:TreatWarningsAsErrors=false /p:EnableWindowsTargeting=true
RUN dotnet publish "Services/SystemManagement/EkampusCore.Services.SystemManagement.Api.csproj" -c $buildConfiguration -o /app/publish/systemmanagement /p:UseAppHost=false /p:TreatWarningsAsErrors=false /p:EnableWindowsTargeting=true
RUN dotnet publish "Services/Reports/EkampusCore.Services.Reports.Api.csproj" -c $buildConfiguration -o /app/publish/reports /p:UseAppHost=false /p:TreatWarningsAsErrors=false /p:EnableWindowsTargeting=true
RUN dotnet publish "Services/Login/EkampusCore.Services.Login.Api.csproj" -c $buildConfiguration -o /app/publish/login /p:UseAppHost=false /p:TreatWarningsAsErrors=false /p:EnableWindowsTargeting=true

FROM base AS final
WORKDIR /app

COPY --from=publish /app/publish/ .

CMD ["./start-services.sh"]


