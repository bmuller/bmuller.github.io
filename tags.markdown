---
layout: default
title: categories of found science
---
# Posts by Tag
{% for cat in site.categories | sort %}
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

