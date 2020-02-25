# TechNewsletter

The engineering way 🤓 of composing a newsletter email 📰📧 in markup language.

## Philosophy

**Q**: Why do I name my custom markup language as `.slm`?

**A**: SLM (aka the English word ***slim***) = **S**uper **L**ightweight **M**arkup.  Isn't it sexy?  🤓  And for the tag delimiter, I've chosen `⇥⇤`, which is rarely used in text content, it means slim as well, just imagine: `⇥)(⇤` it's so vivid!

## Setup

* Run `bundle install` to install all necessary dependencies

## HOWTO

Literally, there is no easier way than this one.

* Prepare your `[source].slm`

  - In custom markup language

  - No nonsense content (I mean HTML tags, CSS styles and etc.)

  - Indentation: 2 spaces (if you use tabs, alright, but it will be normalized to spaces anyway)

  - Please refer to [this example](https://raw.githubusercontent.com/thyrlian/TechNewsletter/master/example.slm)

* Add your own or modify existing HTML fragment inside [`templates` directory](https://github.com/thyrlian/TechNewsletter/tree/master/templates)

* Add or modify corresponding `print_*` private method in [`Factory` class](https://github.com/thyrlian/TechNewsletter/blob/master/lib/newsletter/factory.rb).  Including two major behavior:

  - Parsing the tree data structure from the custom markup language (`.slm`)

  - Rendering HTML fragment

* Run code to compile `.slm` to a fabulous HTML page

## Test

To run unit test: `rake test`

## Compatibility

* Inline CSS is not rendered properly in below email clients:

  - [Airmail](https://airmailapp.com/)
