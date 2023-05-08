# Creating a Package

## What is a Package?

Consider a package to be the same as a directory.

A directory containing files and more directories which represent modules.

## Create a Package

Use the terminal to create a directory named `mypackage`, and add a file named `__init__.py`:

```bash
$ mkdir mypackage
$ touch mypackage/__init__.py
```

> **Note:**
> The `__init__.py` file can be empty, but it can also execute initialization code for the package or set the `__all__` variable, described later.

Then create a module inside the `mypackage` directory named `mymodule.py`:

```bash
$ touch mypackage/mymodule.py
```

**Save this code in the file `mypackage/mymodule.py`**

```python
def greeting(name):
    print("Hello, " + name + "!")
```

## Use a Package

Now we can use the module we just created, by using the `import` statement:

**Save this code in a file named `athing.py`**

```python
import mypackage.mymodule

mypackage.mymodule.greeting("Jonathan")
```

Output:

```bash
$ python3 athing.py
Hello, Jonathan!
```

> **Note:**
> When using a function from a module in a package, use the syntax: `package_name.module_name.function_name`.


## Import From Module

You can choose to import only parts from a module, by using the `from` keyword.

**Save this code in a file named `athing.py`**

```python
from mypackage.mymodule import greeting

greeting("Jonathan")
```

Output:

```bash
$ python3 athing.py
Hello, Jonathan!
```

> **Note:**
> When importing a function from a module in a package, use the syntax: `from package_name.module_name import function_name`.

## Variables in Module

The module can contain functions, as already described, but also variables of all types (arrays, dictionaries, objects etc):

**Save this code in the file `mypackage/mymodule.py`**

```python
person1 = {
  "name": "Kevin",
  "age": 36,
  "country": "Norway"
}
```

**Save this code in a file named `athing.py`**

```python
import mypackage.mymodule

a = mypackage.mymodule.person1["age"]
print(a)
```

Output:

```bash
$ python3 athing.py
36
```

> **Note:**
> When importing a variable from a module in a package, use the syntax: `package_name.module_name.variable_name`.

## Re-naming a Module

You can create an alias when you import a module, by using the `as` keyword:

**Save this code in a file named `athing.py`**

```python
import mypackage.mymodule as mx

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
$ python3 athing.py
Linux
```

