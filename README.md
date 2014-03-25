# MyFace

Fight for control of whose face is online.


## Developer tutorial

This tutorial tells you how to build a slightly simplified version of MyFace.

1.  Install Meteor.

    ```Shell
    $ \curl -L https://install.meteor.com | /bin/sh
    ```

2.  Create a new Meteor application.

    ```Shell
    $ meteor create myface
    $ cd myface
    ```

    All shell commands from here onwards should be executed from your `myface`
    directory.

3.  Start the Meteor development server.

    ```Shell
    $ meteor
    ```

4.  Add the packages we'll be using.

    ```Shell
    $ meteor add accounts-password
    $ meteor add accounts-ui
    $ meteor add coffeescript
    ```

5.  Open a modern web browser (e.g., Google Chrome or Mozilla Firefox) and
    navigate to http://localhost:3000. You should see Meteor's _Hello World_
    application.

6.  Remove the _Hello World_ source files.

    ```Shell
    $ rm myface.*
    ```

7.  Create directories for your server-side, client-side and shared code.

    ```Shell
    $ mkdirs -p lib client/views server
    ```

8.  Create that base HTML, which includes mobile-friendly boiler-plate.

    `client/views/base.html`

    ```Handlebars
    <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="mobile-web-app-capable" content="yes">
      <meta name="viewport"
            content="user-scalable=no, width=device-width, initial-scale=1">
      <title>MyFace - parts of your face online</title>
    </head>

    <body>
      <p>Hello</p>
    </body>
    ```

    Whenever you save, your browser will automatically refresh and show the
    latest version of your site.

9.  Configure the accounts package so that users can create an account with a
    username (as opposed to an email address).

    `client/accounts.coffee`

    ```CoffeeScript
    Accounts.ui.config
      passwordSignupFields: 'USERNAME_ONLY'
    ```

10. Create a template to house the login buttons and the rest of the
    application.

    `client/views/router.html`

    ```Handlebars
    <template name="router">
      {{loginButtons}}
    </template>
    ```

11. Have Meteor render the `router` template by changing the content of the
    `body` tag.

    `client/views/base.html`

    ```Handlebars
    <!-- Snip -->
    <body>
      {{> router}}
    </body>
    ```

