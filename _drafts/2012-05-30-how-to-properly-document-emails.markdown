---
layout: post
title: "How to Properly Document Emails"
date: 2012-05-30 15:15
categories: [email]
---
Most people write emails without propperly documenting them.  The say things like, "The sentences in the email should be clear enough that they're self-documenting," or "If the email is well written, documentation is unecessary."  These arguments are particularly common, but both fail to recognize the complexity that often arises in email development.  Here are some great counter-arguments:

1. Not all sentences in emails are obvious.  For instance, complex trains of thought, sarcasm, and innuendo are not always obvious.
1. Additional information may be necessary to decipher the true meaning of a sentence.  The reader shouldn't have to go find that information somewhere else.
1. Not all readers understand the particular idioms used by the speaker.  Ambiguity should be clarified in comments.

Let's take an example email.

<pre>
Dear engineers,
We're excited to announce that Sally has been promoted to Director of Project Management.
Billy will be taking over her old role, since he has the second most experience.  Furthermore, 
we're excited to announce that Dave will now be moving from his current position of Director of 
Project Management to now drive product innovation throughout the organization.

Congratulations to everyone!  Email me if you have any questions.
</pre>

Now, let's look at how documentation could help clarify many of these statements:

<pre>
# not sure what to call people who write code - but I think "engineers" is a good title
Dear engineers,

# Sally was about to leave, but she's got the most experience, so we have to be 
# "excited" about this
We're excited to announce that Sally has been promoted to Director of Project Management.

# We had no idea who to put in Sally's place.  Next line is necessary because Billy
# is the next best thing - but we're going to continue our search to find someone to
# replace him.
Billy will be taking over her old role, since he has the second most experience.  Furthermore, 

# We're not really excited, because we'd really just like to fire Dave.  We probably will,
# but first we'll give him a more general role that actually doesn't mean anything, so
# set this variable to null for now.
we're excited to announce that Dave will now be moving from his current position of Director of 
Project Management to now drive product innovation throughout the organization.

# This is how things are, and people should realize that automatically, so this line 
# should never get called anyway.
Congratulations to everyone!  Email me if you have any questions.
</pre>

Notice the additional clarity in the second example?  Email should always be documented!