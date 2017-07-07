[![Build Status](https://travis-ci.org/systers/language-translation.svg?branch=develop)](https://travis-ci.org/systers/language-translation)

[![Join the chat at https://gitter.im/systers/language-translation](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/systers/language-translation?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## GSoc Photo Language Translation Project 2015
1. Gsoc timeline : 
2. Developer's Systers profile page : 
3. Link to the deployed application : 

## Features and Specifications
[link to wiki article](https://github.com/systers/language-translation/wiki/Features-and-Specifications)

## Application Structure
[link to wiki article](https://github.com/systers/language-translation/wiki/Application-Structure)

## Framework and specifications

1. Rails 4.2.1
2. Ruby 2.2.3p173
3. PostgreSQL (development, test and deployment)

## How to run this application?

1. Clone the repository.
2. Install PostgesSQL, npm.
3. Rename config/database.yml.example to config/database.yml Update the config/database.yml file with your host name, postgres username and password.
4. To setup the application run, `rake db:setup`.
5. Install bower using npm `npm install -g bower`.
6. To install bower components Run `bower install`.
7. To run the rails application, Run `rails s`.
8. Open `localhost:3000` on your browser to run the application
9. To run the testing suite, Run `rake`.
10. To view the coverage details, Open coverage directory and run `python -m SimpleHTTPServer` and visit `localhost:8000` on your browser.