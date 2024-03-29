# Watchfile Remote

![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/richbl/watchfile-remote?include_prereleases)

**Watchfile Remote** is a simply client-server pattern that configures both a sender (via the `watchfile_remote_sender.sh` script) and a receiver (`watchfile_remote_receiver.sh`) to monitor a single file for changes (called "heartbeat detection"). Both of these scripts are started once, and then run indefinitely in the background.

<picture><source media="(prefers-color-scheme: dark)" srcset="https://github.com/richbl/watchfile-remote/assets/10182110/2b5d9bdf-d05a-4d8f-ba28-9c72c6860357"><source media="(prefers-color-scheme: light)" srcset="https://github.com/richbl/watchfile-remote/assets/10182110/2b5d9bdf-d05a-4d8f-ba28-9c72c6860357"><img src="[https://user-images.githubusercontent.com/10182110/2b5d9bdf-d05a-4d8f-ba28-9c72c6860357](https://github.com/richbl/watchfile-remote/assets/10182110/2b5d9bdf-d05a-4d8f-ba28-9c72c6860357)"></picture>

## Rationale

This project was really created to resolve a very simple use case: how to know when my home internet service goes down--and, more importantly, when it comes back up again--while I'm away from home. This is important because we live in a rural region of Western Washington, and our only internet service is available via DSL, which means above-ground phone lines: and phone lines and trees on windy days don't really behave well together.

So, this project is basically broken down into two parts:

- The sender, which is a local server on our home LAN. This server, as the sender component of this project, periodically (every 5 minutes is the default) attempts to send a "heartbeat" in the form of a simple file up to a remote server (not on our home LAN). Nothing more. Pretty simple.
- The receiver, which is located on one of my remote web servers, will watch for any "heartbeat" updates to that watchfile at an interval of every (n) minutes (10 minutes is the default). If that watchfile has been modified in the intervening (n) minutes, then my home internet service is up and running. On the other hand, if that watchfile hasn't changed, it would suggest that my home internet service is down, so the receiver sends me an email with the bad news.

### Wait a Second!... You Already Wrote This as a Rust Project

Yep, that's right. [**Watchfile Remote [Rust Edition]** was written entirely using Rust and delivered as binary executables](https://github.com/richbl/rust-watchfile-remote). I wrote that project really as an exercise to understand how Rust can be written in such a way that it abstracts away external dependencies that `bash` scripts--by their very definition--rely upon.

All told, while that Rust implementation makes for a solution with fewer external dependencies, writing this original `bash` script was much quicker and simpler overall (with many fewer lines of code). So, if you're running on hardware with a known Unix-like environment, you might find these `bash` scripts more appropriate for your own use case. However, if you want to see how an equivalent project written in Rust looks, check out [**Watchfile Remote [Rust Edition]**](https://github.com/richbl/rust-watchfile-remote).

## Requirements

- An operational [Bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) environment (Bash 5.2.15 used during development)
- On the receiver, an email system needs to be configured so emails can be sent when appropriate. For this project, the `mailx` program is used
- Recommended: since these scripts are expected to communicate over the internet via the `scp` command, it's highly recommended to establish secure credentials between sender and receiver using an `ssh` key exchange. Using encrypted keys is preferred, but not required: if it's not possible to use a key exchange, the `scp` command can be configured in these scripts to pass in a password instead.

While this package was initially written and tested under Linux (Ubuntu 23.10), there should be no reason why this won't work under other shells or Unix-like operating systems that support the `gsettings` application.

## Basic Usage

**Watchfile Remote** is broken into two separate components: the sender and the receiver. Each component is mapped to one of two scripts:

- For the sender, use the `watchfile_remote_sender.sh` script
- For the receiver, use the `watchfile_remote_receiver.sh` script

### The Sender

The sender component is a local LAN computer (typically a server that's always on). Its role will be to periodically send a token file (called `the_watchfile`) to the receiver.

To configure the sender component:

1. Copy the `watchfile_remote_sender.sh` to the machine in question
2. Configure the script declarations to accurately reflect your machine configuration. Importantly, determine how you want to use the `scp` command: either by passing a password directly into the script, or by establishing an ssh key exchange (preferred)
3. Run the script in the background with the following syntax: `./watchfile_remote_sender.sh &` (note that using the `nohup` command may be prepended to the command in the event the script terminates after user logout)
4. Note that nothing appears to be happening. That's good: nothing should be happening, as this script is simply looping through a 5-minute wait, and then quietly copying a file up to the receiving server
5. To confirm that the script is running, type `ps -ef | grep -i watch` and you should see the `watchfile_remote_sender.sh` script running

### The Receiver

The receiver component is a remote computer not on the local LAN (typically a remote web server, or similar machine to which you have access). Its role will be to periodically watch for modifications to a token file (called `the_watchfile`) sent by the sender.

To configure the receiver component:

1. Copy the `watchfile_remote_receiver.sh` to the machine in question
2. Configure the script declarations to accurately reflect your machine configuration
3. Run the script in the background with the following syntax: `./watchfile_remote_receiver.sh &` (note that using the `nohup` command may be prepended to the command in the event the script terminates after user logout)
4. Note that nothing appears to be happening. That's good: nothing should be happening, as this script is simply looping through a 10-minute wait, and then quietly checking a file called `the_watchfile` for any recent updates
5. To confirm that the script is running, type `ps -ef | grep -i watch` and you should see the `watchfile_remote_receiver.sh` script running

## Roadmap

- At the moment, there's not much of a roadmap to consider. Perhaps these scripts will get rewritten to use Rust. But, in general, these are pretty simple scripts doing some pretty basic stuff. But if you have thoughts, send them my way.
