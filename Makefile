#! /bin/sh
current_user = $USER
CPWD = /home/${USER}/

ifeq ($(m),)
 m = 'updates'
endif

push:
ifeq ($(USER),root)
	@echo "root user, will not push to repository, try with standard user"
else
	@#	make commit m="Added-some-test"
	@echo "Current USER: $(USER)"	
	git add -A
	git commit -m $(m)
	git push origin master
endif


pull:
	git pull origin master

reboot:
	sudo reboot

view-project:
	firefox https://github.com/kaleemullah360/TechToday &

view-profile:
	firefox https://github.com/kaleemullah360 &
