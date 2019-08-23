# IpMan-5xtraining

🥊 IpMan-5xtraining 🥊 is To-do list system for 5xruby. You can see prototype here: [Hand-painted prototype](./prototype/README.md)

## Getting Started
- Ruby version: 2.6.0
- Rails version: 5.2.3
- PostgreSQL version: 11.3
- Clone IpMan-5xtraining from GitHub: `$ git clone https://github.com/chaochaowu/IpMan-5xtraining.git`
- Enter to IpMan-5xtraining: `$ cd IpMan-5xtraining`
- `$ rails db:create`
- `$ rails db:migrate`
- `$ rails db:seed`

## Test Suit
1. Install Google Chrome web-driver
2. Use `$ cd IpMan-5xtraining` to enter project
3. `$ rspec`

## Deploy Step:

IpMan-5xtraining is deployed on heroku and performed with Git.

1. `$ heroku create ip-man-5xtraining`
2. Use `$ git remote -v` to check remote which is the name as heroku

  - heroku  https://git.heroku.com/ip-man-5xtraining.git (fetch)
  - heroku  https://git.heroku.com/ip-man-5xtraining.git (push)

3. `$ git push heroku master`
4. `$ heroku run rails db:migrate`
5. Use `$ heroku pg:psql` to establish a psql session with remote database
6. Conect IpMan-5xtraining: https://ip-man-5xtraining.herokuapp.com

## ER Diagram:
![IpMan ER-Model](https://github.com/chaochaowu/IpMan-5xtraining/raw/prototype/prototype/19.07.08_ipman_ERD.jpg)