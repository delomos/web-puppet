## Customizations for ~/.bashrc

### Usage
Most people prefer to keep their files in ~/bin directory...

I usually keep my structure like so:

	[ ~/.bashrc ] <---------- [ ~/.bash_profile]
  		|
		|-----> [ ~/bin/dotfiles/bashrc ] {{==== this is where this repo comes in
							      |
		                     |-------->[ bash/ ]
		
That said: `git clone https://delomos@github.com/delomos/dotfiles.git`


#### A Practical Example

=== [~/.bashrc file ] === 
This assumes the repo was cloned to the ~/bin director
`source ~/bin/dotfiles/bashrc`

=== [ ~/.bash_profile file ] ===
`if [ -f ~/.bashrc]
	then
		source ~/.bashrc
fi`

then, when you're ready to go:

`source ~/.bashrc` or `source ~/.bash_profile`


Enjoy the lazing up or productivity, which ever comes first!
