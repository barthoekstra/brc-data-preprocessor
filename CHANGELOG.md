# Changelog

## 2021.1 - 2021-07-03
### Added
- A ‘single station count’ mode is added for the spring counts, which can be activated by setting environment variable `SINGLE_STATION_COUNT=yes`

### Changed
- `Non-Juv SteppeE` and `Non-Juv ImperialE` will now be flagged as unexpected records.
- `WhitePel` and `DalPel` will be renamed to `WhiteP` and `DalmatianP` in line with [GBIF dataset](https://doi.org/10.15468/ur0vnh) and [data paper](https://doi.org/10.3897/zookeys.836.29252).
- Extraction of count times from Trektellen is made more robust by removing whitespace in regex search.

## 2019.1 - 2019-07-24
Initial release of the data preprocessor. See [README.md](README.md) for details.