# Cooking recipes by testing first

This repo is a step by step example to learn how to create [Chef][0] cookbooks by testing first.

I'll try to follow the BDD/TDD approach and try the different tools from the Chef's ecosystem such [Test-Kitchen][1], [ChefSpec][2], [ServerSpec][3], [Foodcritic][4]...

I won't try to describe the right way, just what makes more sense to me based in my own experience. It'll serve me to learn the tools, to proof some ideas and to have some examples. Also to have documented problem I'll run into and the solutions I'll find.
I hope this help someone else.

## The process

The process will be:

1. Setup the minimal environment for testing how the new system should behave
1. Create the minimal tests to check if the system behave as I wish
1. Check that the tests doesn't pass
1. Think about the simplest technical way to pass those tests
1. Setup the minimal environment for testing this technical approach
1. Create the minimal tests to check that minimal technical approach
1. Check that the tests doesn't pass
1. Create the minimal recipe to pass the technical tests
1. Check that the tests do pass the technical tests
1. Check that the tests do pass the behavior tests

Once I have this, I will think in another system behavior and repeat the process.

## The use case

As example I will use the following example:

> "I'd like to access with my browser to the system and read the sentence **'Hello world!'** in my browser"

Pretty simple and common, isn't it?

## How to organize the code an examples

I'll call the project **webtest** and I'll create a directory for every step I'll take. Something like this:
```
|-webtest-0
|-webtest-1
|-webtest-2
|-...
`-webtest-X
```

Each directory should be self-explanatory with its own `README` file to explain what is the goal for that step, the dependencies, processes and difficulties found in that step.
See the current ones:

* [Webtest-0](webtest-0/README.md): Setup the testing environment.
* [Webtest-1](webtest-1/README.md): Define the business goal and write the integration tests.
* [Webtest-2](webtest-2/README.md): Define the technical specs and write some unit tests.
* [Webtest-3](webtest-3/README.md): Start writing recipes to pass the tests.

  [0]: http://www.getchef.com/chef/
  [1]: http://kitchen.ci/
  [2]: http://code.sethvargo.com/chefspec/
  [3]: http://serverspec.org/
  [4]: http://www.foodcritic.io/
