#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["HelloContainer/HelloContainer.csproj", "HelloContainer/"]
COPY ["HelloContainer.Data/HelloContainer.Data.csproj", "HelloContainer.Data/"]
RUN dotnet restore "HelloContainer/HelloContainer.csproj"
COPY . .
WORKDIR "/src/HelloContainer"
RUN dotnet build "HelloContainer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloContainer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloContainer.dll"]