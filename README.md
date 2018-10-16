# Hosting Reporter README

## Project Setup

[Installation and Setup](https://github.com/zweitag/rails-project-template/blob/master/doc/install.sample.md)

## Git Branching Model

* Use feature branches
* After finishing a feature, create a pull request for master
* PM reviews the pull request and merges it
* Deployment branches are
  * ``master`` for production

## Continuous integration & Code Quality Tools

Travis CI [![Build Status](https://travis-ci.com/zweitag/hosting-reporter.svg?token=vamYF5DqKwHrLZGwT7Zq&branch=master)](https://travis-ci.com/zweitag/hosting-reporter)

## Exception Tracking

[Sentry Error Notification](https://exceptions.zweitagapps.de/zweitag/hosting-reporter/)

### Server

* [Production Server](https://hosting-reporter.zweitagapps.de/)
  * Owned by Zweitag
  * Maintained by Zweitag
* Server access
  * Contact Felix

## Deployment Workflow

Add deployment remote (one time):
* `git remote add deploy FIRST-LAST@app2.zweitag.zweitagapps.de:hosting-reporter`

Deploy:
* `git checkout master` && `git pull` (make sure your local master is identical to origin/master!)
* `git push [-f] deploy master`

Help:
* `ssh FIRST-LAST@app2.zweitag.zweitagapps.de help`

## Project management

* [Trello](https://trello.com/b/BbCZNlXp/hosting-reporter-todo)
* Time Tracking according to our [Zweitag Timelogging Guidelines](https://docs.google.com/a/zweitag.de/document/d/1X3FMXP9YBeXKJtBo286GzcNVqj_z7wVHwfCkSbWgg1M/edit) with
project [Zweitag Sonstiges*](https://zweitag.letsfreckle.com/time/projects/87412) with tag `#Hosting-reporter`
