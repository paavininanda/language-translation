
# Contributing Guide

We welcome contributions from all contributors, here is a quick guide to get you started.

**Set up the project**
```
$ git clone https://github.com/systers/language-translation.git
$ cd language-translation
$ rake db:migrate
$ rake db:seed
$ bower install
$ rails s
```

**Onboarding**
  - Introduce yourself to the community on Slack! 
  - Pick up an easy issue that you think you can work on.
  Familiarize yourself with the context.  Read up on the existing codebase
   that is relevant to the issue.
   
 **While writing the code**
  - Follow proper styling guidelines for your code. Ensure that your code is style consistent. A useful guide may be found [here](https://github.com/thoughtbot/guides)
  - If you wish to use a static code analyzer, you may use [rubocop](https://github.com/bbatsov/rubocop)
  - Use comments wherever necessary. Comments explain the how and why of code and are useful for maintainers. Make sure your comments are not too numerous or verbose.

**Great, now you have written the code but you need to commit it**
 - Each commit should signify a single atomic change (for eg: a bug fix, enhancement or feature addition). 
 - Avoid bundling all code together under one commit. Your commit history should give clear idea of what your code does.
 A good practice could be limiting each commit to a maximum 100 lines of code. 
 - Squash merge and rebase commits. Clean up your commit history.
 - Do not commit whitespaces in your code. A lot of text editors add auto formatting to code. A useful guide may be found [here](https://stackoverflow.com/questions/3515597/add-only-non-whitespace-changes)
 - [Here's a guide to writing good commit messages.](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
 
 **Raising a Pull Request**
 - Do not bundle more than 5 commits in a single PR. 
 - Create separate PRs for separate features. That makes it easier to review and merge.
 - NEVER close a PR on your own, even if you think it is no longer relevant.
 If you close your PR and then raise a new one, you are basically skipping the feedback process and reviewers wont have an idea of what the original code did and why it was changed to be this way.

#### You have created a PR, wohoo! Wait for comments from reviewers and change your code accordingly.
**Happy contributing**
