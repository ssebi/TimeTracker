# Authentication Use Cases

- As a user I want to be able to login into the app using my e-mail and password
- As a user I want to be informed that my credentials are wrong
	- the message should be displayed on the screen (underneath the logo maybe)
- As a user I want to see a progress indicator while the login is being made

# Homescreen Use Cases
- As a user I want to see Today's logged hours
- As a user I want have a logout button
	- there should be a prompt before doing the actual logout
	- there should be a loading indicator while the user is being logged out
- As a user I want to have an add button which will take me to the `Add New WorkLog` entry screen

# Add WorkLog Use Cases
- As a user I want to have a client picker from where I can select the client I want to log hours for
- As a user I want to have a project picker from where I can select the project I want to log hours for
- As a user I want to have my selection cached so that the second time when I go to the screen I see my previous selection
- As a user I want to have an hour picker
	- hour picker should have a one hour difference selected by default
- As a user I want to have an input view where I can add additional comments
- As a user I want to have a submit button to publish the new work-log
- As a user I want to see the published work-log right after I publish it and I'm taken back to the `Home screen`