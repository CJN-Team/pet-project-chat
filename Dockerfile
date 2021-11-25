#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Pet.Project.Chat.Api/Pet.Project.Chat.Api.csproj", "Pet.Project.Chat.Api/"]
COPY ["Pet.Project.Chat.Domain/Pet.Project.Chat.Domain.csproj", "Pet.Project.Chat.Domain/"]
COPY ["Pet.Project.Chat.Infraestructure/Pet.Project.Chat.Infraestructure.csproj", "Pet.Project.Chat.Infraestructure/"]
RUN dotnet restore "Pet.Project.Chat.Api/Pet.Project.Chat.Api.csproj"
COPY . .
WORKDIR "/src/Pet.Project.Chat.Api"
RUN dotnet build "Pet.Project.Chat.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Pet.Project.Chat.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Pet.Project.Chat.Api.dll"]