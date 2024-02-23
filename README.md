# Elixir: Towers of Hanoi

An implementation of Towers of Hanoi written in Elixir. 

Features
1. Simple example of how to use [phoenix live-view](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html), genserver and [tailwind](https://tailwindcss.com)
2. Can play yourself (manual mode) or be shown how to do it (auto-play)
3. Tracks how many steps are taken to complete 
4. Can run localally or be built into a [docker](https://docs.docker.com) image
5. Decent test coverage inc static analysis with [dialyzer](https://www.erlang.org/doc/man/dialyzer.html)
6. [API documentation](https://garethwebber.github.io/elixir-tower-hanoi/api-reference.html) including [architecture diagrams](https://garethwebber.github.io/elixir-tower-hanoi/HanoiWeb.HanoiGameControllerLive.html)

When I was learning elixir, the examples I saw felt ideomatically OO
(e.g. [1]) rather than  functional so I decided to write one myself, leaning into FP. Having 
got the CLI running, I didn't stop there and ended up building a LiveView web-app because, why not?

Obviously having written this as a critique of structure - feel free to comment on what I have done. All greatfully accepted.

## How to run 

Full details on how to run either as a webapp, gen_server or command line can be [on this page](https://garethwebber.github.io/elixir-tower-hanoi/howtorun.html).

![screenshot](https://garethwebber.github.io/elixir-tower-hanoi/web-view.jpg)

## Architecture

![architecture](https://garethwebber.github.io/elixir-tower-hanoi/architecture.jpg)

## References

[1] https://github.com/wouterken/towers-of-hanoi-elixir
