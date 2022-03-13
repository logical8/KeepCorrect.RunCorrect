FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["KeepCorrect.RunCorrect/KeepCorrect.RunCorrect.csproj", "KeepCorrect.RunCorrect/"]
RUN dotnet restore "KeepCorrect.RunCorrect/KeepCorrect.RunCorrect.csproj"
COPY . .
WORKDIR "/src/KeepCorrect.RunCorrect"
RUN dotnet build "KeepCorrect.RunCorrect.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "KeepCorrect.RunCorrect.csproj" -c Release -o /app/publish

FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=publish /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf