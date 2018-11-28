FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["WebApplicationDockerized/WebApplicationDockerized.csproj", "WebApplicationDockerized/"]
RUN dotnet restore "WebApplicationDockerized/WebApplicationDockerized.csproj"
COPY . .
WORKDIR "/src/WebApplicationDockerized"
RUN dotnet build "WebApplicationDockerized.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "WebApplicationDockerized.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "WebApplicationDockerized.dll"]