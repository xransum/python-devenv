# Creating a Module


## What is a Module?

Consider a module to be the same as a code library.

A file containing a set of functions you want to include in your application.


## Create a Module

To create a module just save the code you want in a file with the file extension `.py`:

**Save this code in a file named `mymodule.py`**

```python
def greeting(name):
    print("Hello, " + name + "!")

greeting("Kevin")
```

Output:
```bash
$ python3 mymodule.py
Hello, Kevin!
```


## Use a Module

Now we can use the module we just created, by using the `import` statement:

**Save this code in a file named `mymodule.py`**

```python
def greeting(name):
    print("Hello, " + name + "!")

```

**Save this code in a file named `athing.py`**

```python
import mymodule

mymodule.greeting("Jonathan")
```

Output:
```bash
$ python3 athing.py
Hello, Kevin!
```

> **Note:** 
> When using a function from a module, use the syntax: `module_name.function_name`.


## Variables in Modules

The module can contain functions, as already described, but also variables of all types (`arrays`, `dictionaries`, `objects`, etc):

**Save this code in the file `mymodule.py`**

```python
person1 = {
    "name": "Kevin",
    "age": 36,
    "country": "Norway"
}

def greeting(name):
    print("Hello, " + name + "!")
```


**Save this code in the file `athing.py`, where we import the `mymodule` module, and access the `person1` dictionary:**

```python
import mymodule

person_name = mymodule.person1["age"]
mymodule.greeting(person_name)
print("Age: " + str(person_name))
```

Output:
```bash
$ python3 athing.py
Hello, Kevin!
Age: 36
```

## Naming a Module

You can name the module file whatever you like, but it must have the file extension `.py`.

That's about it on that, lol.

## Re-naming a Module

Aside from just renaming the file itself for your module, you can instead rename a module by using an alias by using the keyword `as` when importing the module:

```python
import mymodule as mx

a = mx.person1["age"]
print(a)
```

Output:
```bash
$ python3 athing.py
36
```

## Built-in Modules

There are several built-in modules in Python, which you can import whenever you like.

```python
import platform

x = platform.system()
print(x)
```

Output:
```bash
$ python3 myplatform.py
Linux
```


## Using the `dir()` Function

There is a built-in function to list all the function names (or variable names) in a module, here's an example:

```python
import platform

x = dir(platform)
print(x)
```

Output:
```bash
$ python3 mydir.py
['__all__', '__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__', '_syscmd_file', '_syscmd_uname', 'architecture', 'dist', 'libc_ver', 'linux_distribution', 'mac_ver', 'machine', 'node', 'os', 'platform', 'processor', 'python_branch', 'python_build', 'python_compiler', 'python_implementation', 'python_revision', 'python_version', 'python_version_tuple', 'release', 'system', 'uname', 'version', 'win32_edition', 'win32_is_iot', 'win32_ver', 'w', 'x86', 'xdg']
```

> **Note:**
> The `dir()` function can be used on all modules, also the ones you create yourself.


## Import From Module

You can choose to import only parts from a module, by using the `from` keyword.

```python
from mymodule import person1

print (person1["age"])
```

Output:
```bash
$ python3 athing.py
36
```

> **Note:**
> When importing using the `from` keyword, do not use the module name when referring to elements in the module. Example: `person1["age"]`, not `mymodule.person1["age"]`.

