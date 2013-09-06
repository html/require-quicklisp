# About 

This piece of software is used for quicklisp local installation. Local means one per project.

It is useful for things you should run on different environments. 

You just clone your repository and just run your application.  

It loads existing quicklisp or tries to install if it does not exist. 
It installs also packages of **specified** quicklisp version. 

And that gives us **some portability guarantee** - on any environment you'll receive packages with versions equal to original.

So, you don't have to include .quicklisp directory into repository but you should include this repository (or at least a file from it) 
and tell what quicklisp dist version you want to use.

# Usage

## Using .quicklisp-version

Clone this repository into .quicklisp-install directory copy file .quicklisp-version to your app directory
and load ".quicklisp-install/require-quicklisp.lisp"

Quicklisp will be loaded from ".quicklisp" directory or installed there.

## Using require-quicklisp function without .quicklisp-version

You can also use require-quicklisp function, 
in this case don't copy .quicklisp-version, 
just load  ".quicklisp-install/require-quicklisp.lisp" and evaluate `(require-quicklisp :version "2013-01-28")`
with your version specified

# Quicklisp version

For using of latest quicklisp packages set see http://www.quicklisp.org/beta/ 
Take date from there, transform it into appropriate format and tell it to script (see Usage)
