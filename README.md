# brc-data-preprocessor <a href="https://www.batumiraptorcount.org"><img src="https://static1.squarespace.com/static/5b33912fb27e39bd89996b9d/t/5b33ac53352f535c7e8effcb/1560539069142/?format=120w" alt="BRC logo" align="right" width="175" style="max-width: 175px;"></a>
The data preprocessor checks the raw [Batumi Raptor Count](https://www.batumiraptorcount.org) data coming straight from the [Trektellen](https://www.trektellen.org) database. It flags records containing possibly erroneous or suspicious information, but *does not delete any data*. It is up to coordinators and data technicians to decide what to do with the flagged records.

Author: Bart Hoekstra | Mail: [bart.hoekstra@batumiraptorcount.org](mailto:bart.hoekstra@batumiraptorcount.org)

## General workflow
The preprocessor runs on [Amazon Lambda](https://aws.amazon.com/lambda/) and regularly checks the [Trektellen](https://www.trektellen.org) site for newly uploaded [BRC counts](https://www.batumiraptorcount.org/migration-count-data). If both stations have uploaded data for the day, the fetcher will download the data and store a raw version of the data in Dropbox (in e.g. `2019/data/raw`). The preprocessor subsequently checks a copy of the raw data for all kinds of possible errors and flags them by adding a description of the potential problem to a `check` column in the file stored in `2019/data/inprogress`. It is then up to coordinators to use their experience and knowledge of the migration during a given day to determine the validity of the flags added by the preprocessor and act accordingly. Once they have dealt with these issues and emptied the `check` column of flags, the file can be moved to `2019/data/clean`. A copy of the checked file gets stored in `2019/data/inprogress-backup`, so data technicians can check how changes to the data have been made.

## Flagged records
The following records will be flagged by the preprocessor:
- Records with invalid doublecount entries (e.g. not within 10 minutes or with the wrong distance code).
- Records containing >1 bird that is injured and/or killed (rare occurrence).
- Records lacking critical information in `datetime`, `telpost`, `speciesname`, `count` or `location` columns (very unlikely, but the possible result of a bug).
- Records of birds in >E3 (rare occurrence).
- Records with registered morphs for all species other than Booted Eagles (and Eleonora's Falcons).
- Records of `HB_NONJUV`, `HB_JUV`, `BK_NONJUV` and `BK_JUV` if the number of aged birds is higher than the number of counted birds (`HB` and `BK`) within a 10-minute window around the age record.
- Records of Honey Buzzards that should probably be single-counted (at Station 2 during the HB focus period).
- Records of aged Honey Buzzards and Black Kites outside of expected distance codes (i.e. outside of W1-O-E1).
- Records containing unexpected combinations of sex and/or age information.
- Records with no timestamps, which are set to 00:00:00 during processing.
- Records containing non-protocol species.
- Records with age details in `W3`, `E3` and `>E3`, excluding non-juvenile harriers with a sex, juvenile `MonPalHen` and juvenile/non-juvenile eagles.
- Records of female Pallid Harriers with `I` or `A` age (legal per protocol, though very difficult to age in the field).

## Todo
- [x] Implement automatic download of the data, flagging of suspicious records and storing of the data in Dropbox using AWS Lambda.
- [x] Automatically add `START` and `END` records to fetched data based on count start and end times.

## Future additions
- [ ] Implement checks for possibly erroneous records based on some statistical rules, e.g. the expected (daily) phenology of a species.

## Build Lambda deployment Docker image (requires Docker and AWS CLI)
1. Clone this repository.
2. `cd` into this directory.
3. Build the [Docker](https://docs.docker.com/install/) image to generate a deployment image for the function.
    ```
    docker build --platform linux/amd64 -t brc-data-preprocessor-docker:v1 . 
    ```
4. Tag docker image. Replace XXXXXX with your account ID.
    ```
    docker tag brc-data-preprocessor-docker:v1 XXXXXX.dkr.ecr.eu-central-1.amazonaws.com/brc-data-preprocessor-docker:latest
    ```
5. Push docker image to Amazon container repository. Replace XXXXXX with your account ID.
    ```
    docker push XXXXXX.dkr.ecr.eu-central-1.amazonaws.com/brc-data-preprocessor-docker:latest
    ```
6. Update function. Replace XXXXXX with your account ID.
    ```
    aws lambda update-function-code --function-name brc-data-preprocessor-docker \
    --image-uri XXXXXX.dkr.ecr.eu-central-1.amazonaws.com/brc-data-preprocessor-docker:latest
    ```