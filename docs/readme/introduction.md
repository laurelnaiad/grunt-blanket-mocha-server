`grunt-blanket-mocha-server` is a lightweight helper task to easily
configure a server for use with <a
href="https://github.com/ModelN/grunt-blanket-mocha" target="_blank">grunt-blanket-mocha</a>.

It helps automate the use of the three great tools:

* <a href="http://gruntjs.com" target="_blank" title="Grunt Website">Grunt</a>
* <a href="http://blanketjs.org/" target="_blank" title="BlanketJS Website">Blanket</a>
* <a href="http://visionmedia.github.io/mocha/" target="_blank" title="Mocha Website">Mocha</a>

**It is not distributed, maintained nor recommended by the
authors of any of these tools.**

<div style="clear: both"></div>

Absent this task, when you want to run your grunt-blanket-mocha
task(s), you need to author a test runner file and run a server
*(blanket cannot be run on local files without browser tweaks)*.  The
**purpose** of this task is to:

* provide a test runner template;
* to allow task-based configuration of the aspects of that runner that
matter when you're testing; and
* to serve the test runner files on the port of your choice.

This can be useful if you don't feel like bothering to author
this file, you're not sure *how* to author the file, or you need to
  configure your test runner on-the-fly during your
grunt process.  Most of what this task does can be overridden in your
Gruntfile.

__If you are not already using grunt-blanket-mocha__, consider this a
recommendation to <a
href="https://github.com/ModelN /grunt-blanket-mocha"
target="_blank">take a look now</a>.  It is assumed you know
why you would use it and that you will refer to its documentation to
understand how to use it.

It is also possible to use this task *without* `grunt-blanket-mocha`
-- to run your tests in a browser, for example.
