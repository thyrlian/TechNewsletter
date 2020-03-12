# TechNewsletter

The engineering way 🤓 of composing a responsive design newsletter email 📰📧 in markup language.

<img src="https://github.com/thyrlian/TechNewsletter/blob/master/assets/images/Intro.png?raw=true">

## Philosophy

**Q**: Why not to use any email marketing automation platform?

**A**: Drag and click?  Come on, we're engineers, there is a better way.  Limited features for editing?  They have, but we don't.  We offer free, open source software, with maximum flexibility for customization.

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

* [ ***Optional*** ] Add your own or modify existing HTML fragment inside [`templates` directory](https://github.com/thyrlian/TechNewsletter/tree/master/templates)

* [ ***Optional*** ] Add or modify corresponding `*Printer` class (which inherits [`Printer` class](https://github.com/thyrlian/TechNewsletter/blob/master/lib/newsletter/printers/printer.rb)) under [`printers` directory](https://github.com/thyrlian/TechNewsletter/tree/master/lib/newsletter/printers).  Including two major behavior:

  - Parsing the tree data structure from the custom markup language (`.slm`)

  - Rendering HTML fragment

* Run code to compile `.slm` to a fabulous HTML page

## Test

To run unit test: `rake test`

## Compatibility

* **External CSS**: When you host the CSS file on GitHub (not [GitHub Pages](https://pages.github.com/)), even if you specify `type="text/css"`, GitHub will respond the CSS file with MIME type `text/plain`, and your browser won't be able to render the CSS.

  - Chrome: `Cross-Origin Read Blocking (CORB) blocked cross-origin response with MIME type text/plain.`

  - Firefox: `The resource was blocked due to MIME type (“text/plain”) mismatch (X-Content-Type-Options: nosniff).`

  - Safari: `Did not parse stylesheet because non CSS MIME types are not allowed when 'X-Content-Type: nosniff' is given.`

  - Workaround: Route the CSS file hosted on GitHub via a free open source CDN such as [jsDelivr](https://www.jsdelivr.com/?docs=gh), which will eventually respond it with the proper MIME type text/css.  Just like this: `<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/USERNAME/REPOSITORY/.../YOUR.CSS" />`

* **Inline CSS** can not be rendered properly in some email clients.

* **Embedded Image** vs. **Linked Image**: For the sake of better support, this tool only uses linked image at the moment.  To learn more details regarding the comparison, please read [this](https://blog.mailtrap.io/embedding-images-in-html-email-have-the-rules-changed/).

* **SVG** is supported in some email clients, as stated [here](https://www.campaignmonitor.com/css/text-fonts/svg/).  Furthermore, depends on the way how you use it, the [support behavior](https://css-tricks.com/a-guide-on-svg-support-in-email/) from the same client may change.  Last, let's say at the moment Gmail blocks SVG by its proxy, but if you read the email in another client (e.g. Airmail), which links to your Gmail account, you could still view the SVG without any problem.

✅ Verified email clients:

* [Gmail](https://www.google.com/gmail/) (Web, Android, iOS)

* [Airmail](https://airmailapp.com/) (macOS)

* [Apple Mail](https://en.wikipedia.org/wiki/Apple_Mail) (macOS, iOS)

* [Outlook](https://outlook.live.com/) (Web)

## License

Copyright (c) 2016-2020 Jing Li.  It is released under the [MIT License](https://opensource.org/licenses/MIT).  See the [LICENSE](https://raw.githubusercontent.com/thyrlian/TechNewsletter/master/LICENSE) file for details.  Additionally, you must give credit by providing a link to this repository at the footer of your generated newsletter.  Thank you.

## Attribution

The social media icons used in this project are from [Font Awesome](https://fontawesome.com/) licensed under [CC BY 4.0 License](https://creativecommons.org/licenses/by/4.0/).
