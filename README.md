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

1. Clone the repository : `git clone https://github.com/systers/language-translation.git`. Check into the directory after cloning.

2. Install PostgreSQL (Version 8.2 and above supported) and npm.

3. Rename config/database.yml.example to config/database.yml : 
`mv config/database.yml.example config/database.yml`.

4. Update the config/database.yml file with your host name, postgresql username and password.

5. To setup the application run, `rake db:setup`.

6. Install bower using npm : `npm install -g bower`.

7. To install bower components, Run `bower install`.

8. To setup SMTP for forgot_password functionality, signup with SendGrid and get SMTP domain, username and password values.

9. Create a config.env file in the root of the application containing the above values. Refer config.env.example file for more info.

10. To run the rails application, Run `rails s`.

11. Open `localhost:3000` on your browser to run the application.

12. To run the testing suite, Run `rake`.

13. To view the coverage details, From application root, open coverage directory (`cd coverage`) and run `python -m SimpleHTTPServer` and visit `localhost:8000` on your browser.