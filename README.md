Introduction
============

This application is a Sinatra-based web app for authorizing our developer
trainees with GitHub and then creating a developer-training tacking repository
for them on GitHub.

The training repo is created in the trainee's account, and select staff are
added as "outside collaborators" to it.

Setup
=====

Clone the repository and run the setup script

```bash
script/setup
```

Configuration
=============

`application.yml`
-----------------

You'll need an OAuth app on GitHub in order to interact with the GitHub
API. See "[Creating an OAuth App][oaa]" for more information. For local
development, create an app with an "authorization callback URL" of
`http://localhost:9292/auth/github/callback`.

Finally, if you want to interact with the GitHub API in the developer console,
You can create a [Personal Access Token][pat] (PAT). This is optional, but if
it's defined in the config, then `@training` in the console will be initialized
with that token.

`collaborators.yml`
-------------------

This is just a YAML array containing the GitHub usernames that will be added to
a trainee's repository as collaborators.

`qualifications.yml`
--------------------

Each YAML document in this file corresponds to an issue that the trainee will be
assigned to complete. Each document can have the following fields:

* `title`: This will be the issue title, it's **required**
* `description`: This will be the issue body
* `subtasks`: This is an array of "sub-tasks" that will be used to construct a
  GitHub-flavored Markdown task-list appended to the issue body.

This file is kept in source-control with the intention that changes to our
training process can go through the normal PR, review, merge process.

`README.md.erb`
---------------

This is the template used for new training repositories. It's passed to an
instance of `DevTraining::Readme`, see the documentation for more information.

Running the App
===============

It's a Rack app, so just `bundle exec rackup` should do it.

Developing
==========

Developer Console
-----------------

```bash
script/console
```

will load the `ApplicationConfiguration`, require the `DevTraining` libraries,
and (if possible) initialize a `DevTraining` with your PAT to `@training`.

Docs
----

API Documentation is generated with RDoc:

```
bundle exec rake rdoc
```

The [compiled documentation][docs] is available in the GH pages environment for
this project.

Tests and Linting
-----------------
RSpec, Rubocop, and Haml-Lint are in the `Gemfile`. You can run then the usual
way. Alternatively, the default Rake task,

```bash
bundle exec rake
```

will run all of them (stopping on the first tool to fail).

[oaa]: https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app
[pat]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[docs]: https://umts.github.io/dev-training-web/
