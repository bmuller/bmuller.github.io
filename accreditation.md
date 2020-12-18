---
layout: default
title: Accreditation Test
---

<div id="parallel-message"></div>
<div class="parallel-login-button"></div>
<script src="//app.parallelmarkets.com/sdk/v1/parallel.js"></script>
<script>
  Parallel.init({ client_id: 'qowozU04A0bjH0VTNpRJ8', environment: 'demo' });
  Parallel.subscribeWithButton(function () {
    document.getElementById("parallel-message").innerHTML = "Thanks for sharing your status.  We'll be in touch soon."
  }, function () {
    document.getElementById("parallel-message").innerHTML = "It looks like you canceled the process.  Please click the button again below to try again."
  })
</script>
