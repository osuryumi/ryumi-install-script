# ryumi-install-script
Script that will install Ryumi's source.

THIS IS WILL NOT WORK ON WINDOWS!!!

# What is this?
It's an installer that will automatically setup an osu! private server based off of Ryumi's source for those who want to save time or don't know how to make one themself.

# How to use it?
It's simple. Firstly, you need to download it by either downloading it from GitHub, or running this command to download: `wget https://raw.githubusercontent.com/osuryumi/ryumi-install-script/master/install.sh`

After you do this, copy, paste and run the command: `chmod +x install.sh && ./install.sh`, and it will take you into the install process!

Make sure you set your DNS like this:

* YOUR-DOMAIN
* c.YOUR-DOMAIN
* i.YOUR-DOMAIN
* a.YOUR-DOMAIN
* s.YOUR-DOMAIN
* old.YOUR-DOMAIN

IF YOU HAVE ANY ISSUES WITH THIS SCRIPT JOIN <a href="discord">RYUMI'S DISCORD</a> AND MESSAGE JAMES!!

Once the installer has finished, follow the below instructions to start up everything:

To start the score server, do these commands:

`tmux new -s lets`

THEN YOU WILL BE TAKEN INTO SOMETHING CALLED A TMUX WINDOW, YOU SHOULD SEE A GREEN BOX AT THE BOTTOM SHOWING THAT YOU ARE IN TMUX

Once you are sure you are in the tmux window, follow the rest of these instructions:

`cd /root/ripple/lets`
`python3 lets.py`

Now, the score server should be running! To exit this tmux window to carry on with the installation process, press Ctrl + B, then the D key afterwards (not at the same time as CTRL + B or it will NOT work)

Next, we want to start the bancho server (logging in, spectators etc):

`tmux new -s bancho`

THEN YOU WILL BE TAKEN INTO SOMETHING CALLED A TMUX WINDOW, YOU SHOULD SEE A GREEN BOX AT THE BOTTOM SHOWING THAT YOU ARE IN TMUX

Once you are sure you are in the tmux window, follow the rest of these instructions:

`cd /root/ripple/pep.py`
`python3 pep.py`

Now, the bancho server should be running! To exit this tmux window to carry on with the installation process, press Ctrl + B, then the D key afterwards (not at the same time as CTRL + B or it will NOT work)

Next we want to start the API (handles leaderboards and more):

`tmux new -s api`

THEN YOU WILL BE TAKEN INTO SOMETHING CALLED A TMUX WINDOW, YOU SHOULD SEE A GREEN BOX AT THE BOTTOM SHOWING THAT YOU ARE IN TMUX

Once you are sure you are in the tmux window, follow the rest of these instructions:

`cd /root/ripple/api`
`./api`

Now, the API server should be running! To exit this tmux window to carry on with the installation process, press Ctrl + B, then the D key afterwards (not at the same time as CTRL + B or it will NOT work)

Next we want to start the avatar server (handles avatars):

`tmux new -s avatar`

THEN YOU WILL BE TAKEN INTO SOMETHING CALLED A TMUX WINDOW, YOU SHOULD SEE A GREEN BOX AT THE BOTTOM SHOWING THAT YOU ARE IN TMUX

Once you are sure you are in the tmux window, follow the rest of these instructions:

`cd /root/ripple/avatar-server`
`./avatar-server`

Now, the avatar server should be running! To exit this tmux window to carry on with the installation process, press Ctrl + B, then the D key afterwards (not at the same time as CTRL + B or it will NOT work)

Next we want to start hanayo (handles website):

`tmux new -s hanayo`

THEN YOU WILL BE TAKEN INTO SOMETHING CALLED A TMUX WINDOW, YOU SHOULD SEE A GREEN BOX AT THE BOTTOM SHOWING THAT YOU ARE IN TMUX

Once you are sure you are in the tmux window, follow the rest of these instructions:

`cd /root/ripple/hanayo`
`./hanayo`

Now, everything is started and the server is ready!
