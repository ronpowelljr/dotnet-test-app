FROM mcr.microsoft.com/dotnet/core/aspnet:3.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["CalcMvcWeb/CalcMvcWeb.csproj", "CalcMvcWeb/"]
RUN dotnet restore "CalcMvcWeb/CalcMvcWeb.csproj"
COPY . .
WORKDIR "/src/CalcMvcWeb"
RUN dotnet build "CalcMvcWeb.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CalcMvcWeb.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CalcMvcWeb.dll"]
