highrise
========

Highrise - A service to manage data for multi-tenant Puppet systems.

---

Motivation
==========
Facilitate running Puppet as a service with the aim of allowing puppet users to focus on writing puppet code, not maintaining a complex architecture.

---

Goals
=====
* Support multiple environments in an automated fashion
* no interactive logins to puppet servers
* Leverage GitHub
* RESTful API

---

Design
======
* RESTful API
  * JSON
  * Ruby
  * Sinatra
  * Simple MySQL backend
* Modules
  * Associate environment with git repo that contains Puppetfile
* Hiera
  * Associate environment with git repo for Hiera
* Node classification
  * Associate environment with git repo for manifests
* Schema
  * environment name (uniq)
  * primary and optionally secondary name and email
  * git repo URL's

---

How it works
============
* Sign up for access by providing info from schema above (done through API)

* Environment info is written on Puppet master so that Hiera can read it.

* Puppet run is initiated which creates the following for each environment
  * environment entries in puppet.conf
  * directories on filesystem
  * public/private keys

* Update any git repo, then tell Highrise to deploy
  * it will update your repo's and checkout the correct branch or tag

---

API Routes
==========
* These are all prepended with /v1.0.0/ or whatever the version.
* The API is all JSON.
* This is a non-exhaustive list

`GET /environments` - list environments<br/>
`GET /environment/:name` - info on a specific environment<br/>
`GET /environment/:name/key` - public key<br/>
`POST /environment/:name/create` - create environment<br/>
`POST /environment/:name/update` - update repo's<br/>

---

Security Model
==============
* Builds on top of Puppet's security model
* Anyone can sign up for an environment
* Owner is in charge of what is in the git repo's - Highrise only updates the code on the Puppet servers
* SSL Support
* Rate limiting

___

Local Setup
===========
    git clone git@github.com:ghoneycutt/highrise.git
    cd highrise
    mysql -u root -p < ext/create_db.sql
    mysql -u root -p highrise < ext/populate_test_data.sql # optional
    shotgun
