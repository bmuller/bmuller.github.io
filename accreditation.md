---
layout: default
title: Accreditation Test
---

<div id="parallel-message"></div>
<div class="parallel-login-button"></div>
<script src="//app.parallelmarkets.com/sdk/v1/parallel.js"></script>
<script>
  Parallel.init({ client_id: 'qowozU04A0bjH0VTNpRJ8', api_location: 'https://demo-api.parallelmarkets.com', verbose: true, allowed_host: 'demo.parallelmarkets.com' });
  function parallelProcessComplete(result) {
    if (result.status === 'connected') {
      document.getElementById("parallel-message").innerHTML = "Thanks for sharing your status.  We'll be in touch soon."
    } else if (result.status === 'not_authorized') {
      document.getElementById("parallel-message").innerHTML = "It looks like you canceled the process.  Please click the button again below to try again."
      Parallel.showButton()
    } else {
      Parallel.showButton()    
    }
  }
  // in case someone is logged in on page load, or redirect process was used (default on mobile)
  Parallel.getLoginStatus(parallelProcessComplete)
  // if someone logs in via overlay
  Parallel.subscribe('auth.statusChange', parallelProcessComplete)
</script>