# Rick and Morty Demo

[![CI](https://github.com/lorenacimpean/rick_and_morty_demo/actions/workflows/ci.yml/badge.svg)](https://github.com/lorenacimpean/rick_and_morty_demo/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/endpoint?url=https://lorenacimpean.github.io/rick_and_morty_demo/badge.json)](https://lorenacimpean.github.io/rick_and_morty_demo/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

A Flutter demo of MVVM on the [Rick and Morty GraphQL API](https://rickandmortyapi.com/graphql), with offline caching, streams and a full test setup.

## Features

- **Characters**: search by name, filter by status, infinite scroll
- **Episodes**: every episode, grouped by season
- **Favorites**: saved on the device, shown in their own tab
- **Character details**: profile, origin, location and episodes

## Architecture

```
View → ViewModel (Cubit) → [Use case] → Repository → GraphQL client | Hive
```

- **View**: screens observe their view model, nothing else
- **ViewModel**: a Cubit with a sealed state (loading, error, success); subscriptions and subjects close with it
- **Use case**: only where there's real logic, such as grouping episodes by season
- **Repository**: streams of models, cache first, then network; GraphQL types never leave it
- **Errors**: typed (`AppErrorType`), turned into words in one place

## Stack

| Concern | Choice |
|---|---|
| State | `flutter_bloc` Cubits, `freezed` sealed states |
| Network | `graphql` with its Hive cache (`cacheAndNetwork`) |
| Models | `freezed` + `json_serializable` |
| Streams | `rxdart` |
| Storage | Hive CE (favorites) |
| DI | `get_it` |
| Routing | `go_router`, one shell route for the tabs |

## Project structure

```
lib/
├── core/      # DI, router, theme, network client and errors
├── data/      # GraphQL queries, models, repositories
├── domain/    # use cases
└── ui/        # one folder per screen, plus shared components
```

## Testing

- **Unit tests**: view models, use cases, repositories and models (`mocktail`, `bloc_test`)
- **Integration tests**: one file per screen covering navigation, positive, negative, limit and edge cases, written with page objects. Positive cases use the real API; errors use a simulated offline connection
- **CI**: analyze, unit tests and iOS integration tests run in parallel on every PR
- **Coverage**: at least 80%. Each PR gets a comment with the change against `master`, and the [report and history](https://lorenacimpean.github.io/rick_and_morty_demo/) live on GitHub Pages

## Getting started

Flutter is pinned with [fvm](https://fvm.app) (`.fvmrc`).

```bash
make build        # packages and generated code
fvm flutter run
make analyze      # format check and analyzer
make coverage     # unit tests and HTML coverage report (needs lcov)
make integration ARGS="-d <device>"
```

## License

[MIT](LICENSE)
