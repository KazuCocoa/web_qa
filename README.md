# WebQa

WebQa application is a web site for Web Service QA Meeting.
The meeting is hold in Japan.
And first web site about the meeting is [here](https://peraichi.com/landing_pages/view/webqa).

This web app works on https://web-qa.herokuapp.com/ .
Allowd developer can deploy this repository on the above heroku.


# Feature

- Admin
  - Create/Read/Update/Delete vote and user resources.
- Others
  - Can vote for created users.

# Development
## Env
- Erlang 18.0
- Elixir 1.0.5
    - read: `web_qa/blob/master/elixir_buildpack.config`

## Dev env
- read: `web_qa/config/dev.exs`
- `$ mix phoenix.server`
    - or `$ iex -S mix phoenix.server`

# Deployment
- `$ git push heroku master`

# LICENSE
MIT.
Read document of LICENSE if you would like to know more.
