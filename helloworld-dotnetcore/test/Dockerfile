FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 8080
ENV 

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["helloworld-dotnetcore/test/test.csproj", "helloworld-dotnetcore/test/"]
RUN dotnet restore "helloworld-dotnetcore/test/test.csproj"
COPY . .
WORKDIR "/src/helloworld-dotnetcore/test"
RUN dotnet build "test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "test.dll"]
