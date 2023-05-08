# Python Dev Environment


## Introduction

Before proceeding with this guide, it is assumed that you have a basic understanding of Python and know how to use it. If you do not, please refer to the [Python Documentation](https://docs.python.org/3/).

This walkthrough is designed for those who want to develop Python applications locally and deploy them to a server. It is not intended for those who want to deploy their Python applications to a containerized environment.

Creating a local Python development environment can provide a number of benefits for small but passionate developers:

1. **Flexibility**: A local development environment provides you with the flexibility to experiment with different libraries, frameworks, and tools without affecting your production environment.
2. **Ease of debugging**: Having a local environment allows you to easily debug your code and identify issues before deploying it to a production environment.
3. **Improved productivity**: With a local environment, you can work offline and without any interruptions from internet connectivity issues.
4. **Cost-effectiveness**: A local environment is usually more cost-effective than using cloud-based services, especially if you are working on small projects.
5. **Personalization**: You can customize your local environment to suit your needs and preferences, such as choosing your preferred code editor or development tools.

Keep in mind that this guide provides a simplified walkthrough of how to create a local Python development environment and is not intended to be a comprehensive guide. To follow this guide, you should have a basic understanding of the following:

By creating a local Python development environment, you can develop your Python applications in a way that best suits your needs and preferences. This provides you with the freedom and control to experiment, test, and deploy your applications with ease.


## Getting Started

For the best experience, we will create a Python project from scratch. This will allow us to see how everything works together and the usage for each of the steps.

### Optional: Installing an Isolated Version of Python Locally

If you have a local Python installation on your system and don't want to use it, run into issue with dependencies for the version you have installed, or you aren't on a system where you can escalate with root permissions. So, you can install a Python installation to a dedicated local directory and use it for your project.

I've created a script that will allow you to download and install a Python installation to a local directory easily and without the need for root privileges.

```bash
curl -skL https://raw.githubusercontent.com/xransum/python-devenv/main/pyfetch.sh -o ./pyfetch.sh && chmod +x ./pyfetch.sh
```

The script pretty much automates a slightly tedious process of downloading and installing a Python installation to a local directory. The script will also allow you to list the available Python versions to install and install a specific version of Python.

If you'd like to see the process it automates, you can take a peak below in the [Manually Installing a Custom Version of Python](#manually-installing-a-custom-version-of-python) section.

Determine what version you want to install that will best meet your needs. To list the available Python versions to install, run the following command:

```bash
./pyfetch.sh --list
```

For the sake of this walkthrough, we will use a stable version Python 3.8.12.

To download and install a specific version of Python, run the following command:

```bash
./pyfetch.sh 3.8.12
```

The flag `--prefix` is optional. If you do not specify a prefix, the script will install the binaries by default in `./lib/`.

Now that we have a stable version of Python installed locally, we can now get our project started.


### Create a Virtual Environment

To create a virtual environment, we will need to install Python virtualenv so we can create a virtual environment for our project.

If you went through the step [Optional - Installing an Isolated Version of Python Locally](#optional-installing-an-isolated-version-of-python-locally), you will need to adjust the path to the Python binary accordingly.

```bash
./lib/Python-3.8.12/bin/python3 -m pip install --user virtualenv
```

Next, we will create a virtual environment for our project.

```bash
./lib/Python-3.8.12/bin/python3 -m virtualenv ./venv --python=./lib/Python-3.8.12/bin/python3
```

The reason we use the flag `--python` is to force the virtual environment to use the Python binary we downloaded and installed in the previous step, adjusting accordingly to your version(s).

### Activate the Virtual Environment

To activate the virtual environment, run the following command:

```bash
source ./venv/bin/activate
```

You should see the name of your virtual environment in your prompt. It will look something like this:

```bash
(venv) $
```

To verify that you are using the Python binary from your virtual environment, run the following command:

```bash
which python3
```

You should see the path to your virtual environment Python binary. It will look something like this:

```bash
/home/username/myproject/venv/bin/python3
```

Now, this is great and we can start installing packages just for our project.


### Deactivate the Virtual Environment

To deactivate the virtual environment, run the following command:

```bash
deactivate
```


### Install Packages

To install packages, run the following command:

```bash
pip install <package>
```

So this is great, but what happens when you want to deploy your project to a server? You will need to freeze your packages.

You may have in the past run something like `python -m pip install -r requirements.txt` to install packages from a `requirements.txt` file, which works, but becomes tedious when your project has a lot of dependencies.

So the best way to mitigate this issue is to use the `pip freeze` command.


### Freeze Packages

When we freeze our packages, we are essentially creating a `requirements.txt` file that contains all of our project dependencies.

To freeze our packages, run the following command:

```bash
pip freeze > requirements.txt
```

Essentially this pulls all of your installed packages from your virtual environment and writes them to a file, in this case, `requirements.txt`.

Now, when you deploy your project to a server, you can install all of your project dependencies by running the following command:

```bash
pip install -r requirements.txt
```

This will install all of your project dependencies from the `requirements.txt` file.


### Uninstalling Packages

To uninstall a package, run the following command:

```bash
pip uninstall <package>
```

This raises a question, what if you want to uninstall all of your project dependencies? Well, you can do that by running the following command:

```bash
pip uninstall -r <(pip freeze)
```

This is a neat bash trick using [process substitution](https://tldp.org/LDP/abs/html/process-sub.html) to create a temporary file, which in this case is the output of `pip freeze`, and passing it to `pip uninstall` as an argument to uninstall all of your project dependencies.


### Create a Project Directory

Our intention for this project will be to create a Python package, the package will be a simple encryption tool. The encryption will ask the user for a message, then asking for a phrase that will be the key to encrypt the message. The decryption will be done by prompting the user for the encrypted message and the key used to encrypt the message.

So with that in mind, we will create a project with a structure that is similar to the following:

```bash
myproject/
└── src/
    └── mypackage/
        ├── __init__.py
        └── utility.py
```

So let's get started by creating a directory for our project.

```bash
mkdir ./myproject
```


### Create a Python Package

Now that we have our project directory created, we can start creating our Python package.

```bash
mkdir -p ./myproject/src/myproject
```

Now, let's start creating our files for our package.

For our `__init__.py` file, we will leave it empty for now.

```bash
vi ./myproject/src/myproject/__init__.py
```


For our `utility.py` file, we will will create functions to perform the following:

- `encrypt_message`: This function will prompt the user for a message and a key to encrypt the message.
- `decrypt_message`: This function will prompt the user for an encrypted message and a key to decrypt the message.


```bash
touch ./myproject/src/myproject/utility.py
```

```python
def encrypt_message():
    message = input('Enter a message to encrypt: ')
    key = input('Enter a key to encrypt the message: ')
    # TODO: Encrypt the message using the key.
    pass

def decrypt_message():
    encrypted_message = input('Enter an encrypted message to decrypt: ')
    key = input('Enter a key to decrypt the message: ')
    # TODO: Decrypt the message using the key.
    pass
```

With our package created, we can start working on our project, but first, we need to create a virtual environment for our project. This will allow us to install packages locally to our project without affecting our system Python installation.


### Defining the Distribution Package

Before we can start working on our project, we need to define the distribution package. This will allow us to install our package locally to our project.

To define the distribution package, we will need to create a `setup.py` file in the root of our project directory.

```bash
vi ./myproject/setup.py
```

```python
from setuptools import setup, find_packages

setup(
    name='myproject',
    version="0.1",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
    python_requires=">=3.8",
)
```

In the function `setup` we are passing `"src"` explicitly to the `find_packages` function. This is so that the `find_packages` function will only look for packages in the `src` directory. This is important because we don't want to include any packages that are not part of our project.


### Installing the Distribution Package in the Virtual Environment

We can use pip to install the package, though while a package is still under active development, it's prefered to to install with pip using "editable mode" so that way changes can be made to the package and continue testing and development without needing to reinstall.

```bash
pip install --editable .
```

Of course, if `myproject` is not your current working directory (and you don't want it to be), then adjust the path. For instance, if you put `myproject` in your `Documents` directory in your home directory, then something like this may work for you: `pip install --editable ~/Documents/myproject/`

Now, try it out:
```bash
>>> from mypackage import utility
>>> utility.encrypt_message()
Enter a message to encrypt: abcdef
Enter a key to encrypt the message: 1234
>>>
```

### Improving the Package

WIP


### Creating Unit Tests

WIP





### References and Resources

#### Manually Installing a Custom Version of Python

1. Change to your home directory.

```bash
cd ~
```

2. Create a temporary directory.

```bash
mkdir tmp
```

3. Change to the temporary directory.

```bash
cd tmp
```

4. Download the Python source code.

```bash
wget https://www.python.org/ftp/python/3.10.1/Python-3.10.1.tgz
```

5. Extract the Python source code.

```bash
tar zxvf Python-3.10.1.tgz
```

6. Change to the Python source code directory.

```bash
cd Python-3.10.1 
```

7. Configure the Python source code.

```bash
./configure --prefix=$HOME/opt/python-3.10.1
```

8. Compile the Python source code.

```bash
make
```

9. Install the Python binaries.

```bash
make install
```

10. Navigate back to your home directory:
```bash
- cd ~
```

11. To make the new version of Python available for use, you'll need to modify your PATH variable. To do this, you'll need to edit your `.bash_profile` file. If you don't have a `.bash_profile` file, you can create one in your home directory. To edit the `.bash_profile` file, run the following command:

```bash
nano ~/.bash_profile
```

12. To use the new version of Python over the system default, enter the following line to your `.bash_profile`:

```bash
export PATH=$HOME/opt/python-3.10.1/bin:$PATH
```

13. Save and close the file, this can be done by pressing `CTRL + X`, then `Y`, and then `ENTER`.

14. Now we must load the new `PATH` variable into our current shell session. To do this, run the following command:

```bash
. ~/.bash_profile
```

15. Check which version of Python you're now using by entering the following command:

```bash
which python3
/home/username/opt/python-3.10.1/bin/python3
```

16. You can also check the version:

```bash
python3 --version
Python 3.10.1
```

