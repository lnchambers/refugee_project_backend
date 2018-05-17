# Refugee Project.

According to the UNHCR, a record 65.6 million individuals have been forced to flee their homes due to persecution, war, or violence. One person becomes a refugee every three seconds, meaning that the time taken to read this sentence has seen someone become displaced. 

This project utilizes machine learning to leverage data on specific refugee migration patterns to try and reconnect families separated from each other by forced displacement. It is designed to be a tool used by investigators who have been given access by a director.

<img src="https://i.imgur.com/LjTaoxH.png" />
<img src="https://i.imgur.com/NAzfVWd.png" />

# Concerns

* The data used on this site is randomized to prevent malicious usage. The data for this open source project does not correlate with any person, event, or place. The data was randomized with [Faker](https://github.com/stympy/faker).

* Access to the site is provided on a restricted need basis. If you would like access to it, please reach out to [Luke Chambers](https://github.com/lnchambers) directly.

# Contributing

Direct contributing to this repository will currently not be accepted. If an issue is discovered, please reach out to [Luke Chambers](https://github.com/lnchambers) directly.

# Tech Stack

The front end was built using Ruby on Rails using PostgreSQL. Vanilla Javascript and CSS3 was utlized for the styling.

The back end API was built using Ruby for the machine learning, Rails for the framework, and MongoDB for document storage.

The project repo for the front end is [here](https://github.com/lnchambers/refugee_project).

This app is located [here](https://refugee-project.herokuapp.com/). It is hosted on Heroku. The server is set to go to sleep after a while, so if the page takes a while to load, understand that you are waking up the server and further requests will be faster.
