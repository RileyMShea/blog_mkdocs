---
title: Some Random Name
summary: A brief description of my document.
authors:
    - Waylan Limberg
    - Tom Christie
date: 2018-07-10
some_url: https://example.com
---
# Welcome to MkDocs

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell


For full documentation visit [mkdocs.org](https://mkdocs.org).

# Bigger?


## Commands

### Smaller?

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs help` - Print this help message.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.


```python
def func(x):
    return x + 2

print(func(3))

```

#Code {{ func # inspect }}

## Admonition Demo

!!! note
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

!!! note "I am a custom title of the admonition 'Note' type"
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.
    
### Below is an example of an empty title

!!! note ""
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

!!! note "db.sql"
    ``` sql
    SELECT * FROM dual;
    ```
    
## Arithmetix / MathJax

$$
\frac{n!}{k!(n-k)!} = \binom{n}{k}
$$

BetterEm testing

* Won't highlight *

*Will Highlight*

***I'm italic and bold* I am just bold.**

***I'm bold and italic!** I am just italic.*

^^I'm basically just underlined?^^

H^2^0

text^a\ superscript^

:smile: :heart: :thumbsup: :angry:

I'm talking an then suddenly `#!sql select * from dual;`

RileyMShea@gmail.com

http://www.ebay.com

ftp://someaddress.com

ws://127.0.0.1:8000


Some of this text ==might== be highlighted

this might point => to the right

this might point -> to the right

* [x] Lorem ipsum dolor sit amet, consectetur adipiscing elit
* [x] Nulla lobortis egestas semper
* [x] Curabitur elit nibh, euismod et ullamcorper at, iaculis feugiat est
* [ ] Vestibulum convallis sit amet nisi a tincidunt
    * [x] In hac habitasse platea dictumst
    * [x] In scelerisque nibh non dolor mollis congue sed et metus
    * [x] Sed egestas felis quis elit dapibus, ac aliquet turpis mattis
    * [ ] Praesent sed risus massa
* [ ] Aenean pretium efficitur erat, donec pharetra, ligula non scelerisque
* [ ] Nulla vel eros venenatis, imperdiet enim id, faucibus nisi


sometimes you might want to ~~jump~~ fall


!!! tldr "don't do this at home"
    some text now