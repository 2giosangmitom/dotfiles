# Collect Nix garbage
gc:
	sudo nix-collect-garbage -d
	nix-collect-garbage -d

# Optimise Nix store
optimise:
	nix store optimise
	sudo nix store optimise

# View generated profiles
history:
	nix profile history --profile /nix/var/nix/profiles/system
