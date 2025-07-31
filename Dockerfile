FROM mcr.microsoft.com/dotnet/sdk:7.0 AS base
WORKDIR /app
EXPOSE (hangi portlar üzerinden işlem alınacak)

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build 
ARG BUILD_CONFIGURATION=Release(???) 
WORKDIR /src
COPY ['' EKAMPÜS PROJESİNİN csproj dosyası????] (kopyalanacak proje dosyası)
RUN dotnet restore '' COPY SATIRINA EKLENEN KLASÖRÜN ADI '' 
COPY . . 
WORKDIR ''/src/''
RUN dotnet build (csproj dosya adı) -c $BUILD_CONFIGURATION -o /app/build (hangi konfigürasyona build edecek) 

FROM build AS publish 
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish ''(csproj dosya adı) -c $BUILD_CONFIGURATION -O /app/publish /p:UseAppHost=false

FROM base AS final 
WORKDIR /app
COPY --from=publish /app/publish . 
ENTRYPOINT [''dotnet'', ''EKampus.RaporAl.Core.dll'']

