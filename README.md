# README

Receive SMS texts and grab the first article and return a summized version of the article content

This would be particularly cool as a service and would benefit a bunch of third world countryfolk who only have flip phones and want random questions answered

I'm sure there's more to add and may add over time but for the time being it's in a working state and should suffice for my own needs

* Ruby version

2.6.3

* System dependencies

Nothing special

* Configuration

Create a Twilio account, set the TWIML application to point to the correct api endpoint. The default will be `/question`

* Database creation

```powershell
rake db:create
```

* Database initialization

```powershell
rake db:migrate
```

* How to run the test suite

```powershell
rspec spec
```

* Services (job queues, cache servers, search engines, etc.)

There are no job queues setup but one should be setup to handle the sending of sms messages and article summation.

* Deployment instructions

No deployment steps are included. Deploying to heroku would be the easiest but can be deployed anywhere.