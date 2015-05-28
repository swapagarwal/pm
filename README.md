## `pm` is a password magician, useful when you just typed your password in front of someone.

`pm` is a simple bash script made for changing your password according to rules defined by you.

If someone is near you while unlocking your computer (and you are wary of shoulder surfing like me!), you can quickly change your password by providing an input and have some changes applied to it (so that only you may infer the new password).

#### Usage

Use the following command to test whether pm is able to change passwords in your system:

```
pm test [username] [current password] [new password]
```

You can view password changes in `~/.pm.log` file.

Define your password schemes in pm.config file and use it as:

```
pm scheme [schemeName] [arguments(STR/NUM)]...
```

#### Sample usage

Let `myScheme` be a password scheme defined as `"pass" + STR + NUM + "word"`.

You can enter STR and NUM at runtime and have it changed by a predefined rule applied on them.

Let the rule for first `STR` be convert 2nd letter to upper case and multiply by 3 for `NUM`.

For example, `pm scheme myScheme test 4` will set the new password to be `passtEst12word`.

#### Requirements

`pm` requires `expect` to work.

For Ubuntu/Debian based systems, you can install it by:

```
sudo apt-get install expect
```

#### Contributing

This was made as a simple hack for personal use.

I have tested this only on Debian based systems. (Use it at your own risk!)

Feel free to fork and improve it! Also, submit a pull request. :)
