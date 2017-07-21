# GSoC 2017 - PLT Development Update

## Overall Schematic

1. [x] Upload Picture of Object

2. [x] Add content (text-about the picture in English and category- like rivers,food,adjective,pronoun,etc. ) and language name to picture in English.

3. [X] Add content to picture with phonetic text ( It is pronunciation of word of local language – Chuukese here - expressed in english text. Example, building: the phonetic text might be "Bill-Ding". )

4. [x] New photo(article) containing a picture, text and category in English with phonetic text in a particular language and language name is created if a picture or English text or phonetic text fields are filled ,i.e., there is no need for all fields to be filled completely. (Current implementation requires minimum picture and category.)

5. [x] User is able to upload picture. List of articles shows "Uploaded" in column of Picture if the picture is uploaded by user. This picture can be seen by clicking on "Show" link just beside the photo(article).

6. [x] User is able to add content and language name to picture in English.

7. [x] User is able to add content to picture with phonetic text.

8. [x] All present articles can be seen by any user. They can be edited, seen or deleted. Later, delete option will be exercised by all except contributors.

9. [ ] User is able to enter, edit, delete installation contact information. Later, this can be done by only administrator. (The "Later" part isn't updated.)

10. [x] If there are any errors then the form is not submitted and shows errors to users.

11. [x] When user tries to delete an entry then it sends a warning asking: "Are you sure?"

12. [x] Language names are added by user. Later, this functionality will be exercised by administrator only.

13. [x] Language name in any article user can choose it from a drop down box which has only those language names which were added under the "Languages" tab ( languages added by administrator.) or none option if the language name is not in the shown list of languages. This will help peace corps to train their volunteers at any post(installation) or site in any language without any restriction. (None as an option not available.)

14. [ ] All photos(articles) of a paticular language can be seen under the "Languages" tab. User has to click on "Photos" link beside the language name for selecting a paticular language. Volunteers can click on this link for their training in a paticular language. (Not implemented.)

15. [x] CAREFUL! : If a particular language is deleted, all the photos(articles) under that language are automatically deleted.

16. [ ] Volunteer names on a site can be added or deleted from the show page of each site information. (Show page of site is blank.)

17. [ ] Empty string will not be taken as Volunteer name. Hence, if you just click "Create Volunteer" without entering anything in the Volunteer name field, no volunteer will be created. (Unable to find implementation.)

18. [x] Site names in a post(installation) can be added or deleted under Sites tab.

19. [x] Empty string will not be taken as Site name. Hence, if you just click "Create Site" without entering anything in the name field, no site will be created  and the form will show an error message.

20. [ ] All sites under a post(installation) can be seen under "Posts" tab. Click "Show" for a particular post(installation) to see all contact information of post(installation) and number of sites in it. (Unable to find implementation.)

21. [ ] CAREFUL! : If a particular site is deleted, all the volunteer names under that site are automatically deleted. (Will test this and update here.)

22. [ ] CAREFUL! : If a particular post(installation) is deleted, all the sites under that post(installation) are automatically deleted. (What does installation mean here ?)

23. [x] Photos(Articles), Sites, Volunteers and Contributors table are sorted in descending order,i.e., last created is at the top and the first created is at the bottom.

24. [ ] Admin can view and edit the volunteer contact information - except for volunteer's username and password. (Yet to test this as admin panel not working)

25. [ ] Admin can enter the volunteer or contributor to use the application ,i.e., Login Approval = 'Not Yet' (before approval) to Login Approval = 'Yes'(after approval). (Yet to test this as admin panel not working)

26. [ ] Application must work offline. (Unable to find implementation.)

27. [ ] Application must automatically sync with the cloud database to fetch latest information whenever application is connected to the internet. (Unable to find implementation.)

28. [ ] UI Improvements

30. [ ] Approve, Disapprove User and Grant, Revoke Admin functionalities in users_controller not working.

31. [ ] Add and Remove Role functionality in sites_controller not working.

## Using Devise

1. [x] For "Sign Up Form", username, first name, last name, password fields are compulsory. Username field is unique for each user. If the username you chose has already been chosen by someone, then you are asked to enter some other username.

2. [x] Sign In (Log In) using username and password. (Unique username)

3. [ ] Fields like Gender, location - dropdown list of post(installation) names which need to be added in code if new installations are added - in app/views/devise/registrations/edit.html.erb and app/views/users/_form.html.erb , contact number, email id can be added later after sign up form, by clicking on "Edit Profile" link. (Email is made compulsory)

4. [ ] In every sign up form, login approval is 'Not Yet' by default, which will be set by admin for volunteers to login and volunteers and admin for contributers to log in. (Yet to test this as admin panel not working)

5. [x] Change password in "Edit Profile".

6. [x] Delete my own account under "Edit Profile".

7. [ ] Mailer Client (Sideqik/Redis etc.) not setup to work to make "Forgot Password" work. (Unable to find implementation.)

## Using CanCanCan

1. [ ] Articles posted by any user is approved by volunteers/admin. If the volunteer/admin doesn't approve of the article, he/she may delete it. (Yet to test this as admin panel not working)

2. [ ] Any user can edit a photo(article). (Contributor can't edit Language)

3. [ ] Only admin approves the signed up contributors to log into the application. (Yet to test this as admin panel not working)

4. [x] All permissions to admin.

## Framework and specifications

1. Rails 4.2.1
2. Ruby 2.2.3p173
3. PostgreSQL 8.2 and above are supported (development, test and deployment)

## How to run this application?

1. Clone the repository : `git clone https://github.com/systers/language-translation.git`. Check into the directory after cloning.

2. Install PostgreSQL (Version 8.2 and above supported) and npm.

3. Rename config/database.yml.example to config/database.yml : `mv config/database.yml.example config/database.yml`.

4. Update the config/database.yml file with your host name, postgres username and password.

5. To setup the application run, `rake db:setup`.

6. Install bower using npm : `npm install -g bower`.

7. To install bower components, Run `bower install`.

8. To run the rails application, Run `rails s`.

9. Open `localhost:3000` on your browser to run the application.

10. To run the testing suite, Run `rake`.

11. To view the coverage details, From application root, open coverage directory (`cd coverage`) and run `python -m SimpleHTTPServer` and visit `localhost:8000` on your browser.