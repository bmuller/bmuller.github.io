---
layout: default
title: categories of found science
redirect_to: https://bmuller.wtf
---
# Posts by Tag
{% assign sorted_cats = site.categories | sort %}
{% for cat in sorted_cats %}
{% capture tag %}{{ cat | first }}{% endcapture %}
<a name="{{ tag }}">
</a>

## {{ tag | replace:'_',' ' }}
<ul>
{% for post in site.categories[tag] %}
{% include postitem.markdown %}
{% endfor %}
</ul>
{% endfor %}

