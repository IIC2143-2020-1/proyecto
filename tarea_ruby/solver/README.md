# Tarea Solver

## Requirements

There are 2 ways of running this solver:

1. The "normal" way
2. Using `Docker` (if you've never heard of it before, just use the "normal" way)

To run this solver the "normal" way, you need to be using a UNIX-like environment (`Linux`, `macOS`, `WSL`) and have the `ruby` executable in your `PATH`. Tu run this solver using `Docker`, you just need to have `Docker` it installed and in your `PATH`.

## Usage

### The "normal" way (without Docker)

Start by putting your repository inside the `solutions` folder (the `sample-solution` is an example of a repo).

Then, just run the main shell script

```
sh solver.sh
```

Look for the section "Running code from 'your-repo'" to see how your solution compared to the expected solution. Alternative, once the script has been executed, you can go to the newly generated `outputs` directory inside your repo to compare the expected output vs your own output.

### With Docker

Start by putting your repository inside the `solutions` folder (the `sample-solution` is an example of a repo).

Then, build the Docker container image

```
sh build.sh
```

Finally, run the program

```
sh run.sh
```

Look for the section "Running code from 'your-repo'" to see how your solution compared to the expected solution. Alternative, once the script has been executed, you can go to the newly generated `outputs` directory inside your repo to compare the expected output vs your own output.

## What happened?

Every repository was tried to run 3 times, each one with a different dataset, calling its `main.rb` file. A folder named `outputs` was created at the root of each repository, containing a folder named `expected` with the expected output of each dataset and a folder named `tested`, containing the actual output of each dataset.

The console also shows some logs for every repository, declaring `SUCCESS` to those outputs **identical** to the expected output and `FAILURE` to **any other output** (an extra space, for example, would result in a `FAILURE`).
