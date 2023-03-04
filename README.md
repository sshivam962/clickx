# Clickx[ ![Codeship Status for 1ims/clickx](https://app.codeship.com/projects/53729310-06e5-0135-1ec3-620605e29639/status?branch=master)](https://app.codeship.com/projects/213933) [![CircleCI](https://circleci.com/gh/1ims/clickx.svg?style=svg&circle-token=c06cc3d412274d2d11e5987244af9d9f3d979c9a)](https://circleci.com/gh/1ims/clickx)

Everything You Need to Generate Traffic, Measure Leads and Convert Customers Online

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* Linux or Mac OS or Windows
* Postgres 9.5 or above
* Redis
* Memcached
* Ruby 2.4.2
* Yarn

### Installing on Windows

Please the detailed windows installation guide wiki here: [Window Setup Guide](https://github.com/1ims/clickx/wiki/Windows-Setup-Guide)

### Installing on Mac

A step by step series of examples that tell you have to get a development env running

```
git clone https://github.com/1ims/clickx
```
```
cd clickx
```
```
bin/setup
```
Run the rails server
```
rails s
```
Visit localhost:3000 to get the local running instance

## Running the tests

```
bundle exec rspec
bundle exec cucumber
```

### Coding style tests

Use pronto for checking coding style issues before commiting the code

```
pronto run
```

## Deployment

Clickx is currently deployed in heroku

pushing code to `staging` branch will auto deploy to staging and production branch will auto deploy to production

## Built With

* [Rails](http://rubyonrails.org/) - The web framework used
* [Angular](https://angular.io/) - Frontend framework


## Documentaion

* [Read documenation](frontend-doc.md)
* [Read Theme dependenices](theme-doc.md)
* [Keyword Ranking](https://github.com/1ims/clickx/wiki/Keyword-Ranking-API)
* [Development workflow](https://github.com/1ims/clickx/wiki/Development-Workflow)



