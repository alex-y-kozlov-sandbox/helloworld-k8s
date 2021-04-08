FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["helloworld-dotnetcore/helloworld-dotnetcore.csproj", "helloworld-dotnetcore/"]
RUN dotnet restore "helloworld-dotnetcore/helloworld-dotnetcore.csproj"
COPY . .
WORKDIR "/src/helloworld-dotnetcore"
RUN dotnet build "helloworld-dotnetcore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "helloworld-dotnetcore.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "helloworld-dotnetcore.dll"]
