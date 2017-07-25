## Photo Language Translation [![Build Status](https://travis-ci.org/systers/language-translation.svg?branch=develop)](https://travis-ci.org/systers/language-translation) [![Join the chat at https://gitter.im/systers/language-translation](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/systers/language-translation?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Link to deployed application
[pc-lang-dev.systers.org](http://pc-lang-dev.systers.org/)

## Features and Specifications
[Wiki/Features and Specifications](https://github.com/systers/language-translation/wiki/Features-and-Specifications)

## Application Structure
[Wiki/Application Structure](https://github.com/systers/language-translation/wiki/Application-Structure)

## Contribution Guide
[Wiki/Contribution Guide](https://github.com/systers/language-translation/wiki/Contribution-Guide)

## Framework and specifications

1. Rails 4.2.1
2. Ruby 2.2.3p173
3. PostgreSQL (development, test and deployment)

## How to run this application?

1. Clone the repository : `git clone https://github.com/systers/language-translation.git`. Check into the directory after cloning.

2. Install PostgreSQL (Version 8.2 and above supported) and npm.

3. Rename config/database.yml.example to config/database.yml : `mv config/database.yml.example config/database.yml`.

4. Update the config/database.yml file with your host name, postgresql username and password.

5. To setup the application run, `rake db:setup`.

6. Install bower using npm : `npm install -g bower`.

7. To install bower components, Run `bower install`.

8. To run the rails application, Run `rails s`.

9. Open `localhost:3000` on your browser to run the application.

10. To run the testing suite, Run `rake`.

11. To view the coverage details, From application root, open coverage directory (`cd coverage`) and run `python -m SimpleHTTPServer` and visit `localhost:8000` on your browser.