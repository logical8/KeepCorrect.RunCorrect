FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["KeepCorrect.RunCorrect/KeepCorrect.RunCorrect.csproj", "KeepCorrect.RunCorrect/"]
RUN dotnet restore "KeepCorrect.RunCorrect/KeepCorrect.RunCorrect.csproj"
COPY . .
WORKDIR "/src/KeepCorrect.RunCorrect"
RUN dotnet build "KeepCorrect.RunCorrect.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KeepCorrect.RunCorrect.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "KeepCorrect.RunCorrect.dll"]
