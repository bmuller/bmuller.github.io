---
layout: default
title: "FindingScience : a blog about startup tech and gallimaufry"
---

{% for post in site.posts offset: 0 limit: 10 %}
<div class="postlistitem">
  {% if post.image %}<div class="post-image"><img src="{{ post.image }}" /></div>{% endif %}  
  {% if post.image_credit %}<div class="post-image-credit">{{ post.image_credit }}</div>{% endif %}

  <h1><a href="{{ post.id | replace: ":", "" }}.html">{{ post.title }}</a></h1>
  <div id="date">Posted {{ post.date | date_to_string }} {% include tags.markdown %}and has <a href="{{ post.id }}.html#disqus_thread">Comments</a></div>
  {{ post.content }}
</div>
{% endfor %}

<div style="text-align: center; font-size: 1.2em;">
  <a href="/archive.html">&laquo; Older Posts &raquo;</a>
</div>