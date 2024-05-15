# jekyll-theme-future-imperfect
A Jekyll adaptation of the Future Imperfect theme by HTML5 UP. See [Credits](#credits) for more info.

## Installation
Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "jekyll-theme-future-imperfect"
```

And add this line to your Jekyll site's `_config.yml`:

```yaml
theme: jekyll-theme-future-imperfect
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-theme-future-imperfect

## Usage

### Theme Layouts
I chose to stick closely to the two pages offered by the original theme and my experience with the [Step By Step Tutorial](https://jekyllrb.com/docs/step-by-step/01-setup/). This led to the following 4 layouts:

**base.html**
: A base layout for others to inherit from. Contains common elements between index and single pages from the original theme. Any page that presents content should be wrapped with this layout.

**default.html**
: The default layout for the theme. Most pages are safe to use this as the content is wrapped in an `<article class="post">` tag, which provides a simple border around the content.

**author.html**
: Displays information about the author and a list of articles written by them.

**post.html**
: Provides structured metadata about the post with the post contents. This layout is wrapped by the default layout.

### Theme Includes
Based on my limited knowledge of website design, it seemed like a good idea to split some of the common markup found in original the theme's index.html and single.html files. This resulted in:

**footer.html**
: Contains the social media, RSS, email, and copyright elements

**head.html**
: Contains the common items of the `<head>` tags for each page

**large_post_preview.html**: Displays a post as a large preview section, used in the site index

**list_post_preview.html**
: Displays a post as a list item, used in individual author pages and the site index

**menu.html**
: Contains the menu which is controlled by the hamburger button in the top right corner of the page.

**navigation.html**
: Contains the top bar of the page displaying the data stored in `_data/navigation.yml`.

**scripts.html**
: Contains the tags to include the Javascript used by this theme

**small_post_preview.html**
: Displays a post as a small preview section, used in `/blog` and the site index.

## TODOs
The theme currently is very simple, lacking features found in other themes. The reason comes down to several factors:

* I am new to Jekyll/Ruby and don't know any better
* I thought about doing something more complicated but felt it was restricting the user
* I didn't know how to do it the right way

Looking at other themes here are some potential ideas:

- Add styling to the Sass assets for syntax highlighting
- Port the theme to use CSS Grid
- Figure out how to expose the palette vars for theme customization
- Add integration with analytics
- Add integration with comments
- Add integration with social media
- Add integration with search
- Figure out a way to avoid hardcoding image paths so that users can structure their project as they like

I am planning on using this theme for my own personal site so hopefully this keep me committed to completing these TODOs.

## Contributing
In light of the previous section, please feel free to submit PRs and contribute. This is my first open source project and would happy to learn the ropes of maintanence if you, dear potential contributor, will have patience for me.

Bug reports and pull requests are welcome on GitHub at https://github.com/ejohnso49/jekyll-theme-future-imperfect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Credits
This Jekyll theme has been adapted for Jekyll from the Future Imperfect created by HTML5 UP. The following modifications were made to the original work:

* Adapted original source for Jekyll compatible directory structure
* Created Jekyll includes/layouts split from original work with added template tags for usage with Jekyll
* Created sample pages to demonstrate usage of theme with Jekyll capabilites

## License
This theme is offered under the Creative Commons 3.0 License. See LICENSE.TXT for the full text, or visit [https://creativecommons.org/licenses/by/3.0/](https://creativecommons.org/licenses/by/3.0/) for more information.

## Copyright
Copyright (c) 2020 Jekyll Adaptations by Eric Johnson, Copyright (c) Theme Design by [HTML5 UP](https://html5up.net), Original Work: [Future Imperfect](https://html5up.net/future-imperfect)

