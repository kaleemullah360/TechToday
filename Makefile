#! /bin/sh
current_user = $USER
CPWD = /home/${USER}/
ifeq ($(C),)
 C = 'updates'
endif
	
push:
	@#	make commit C="Added-some-test"
	git add -A
	git commit -m $(C)
	git push origin master

pull:
	git pull origin master

reboot:
	sudo reboot

view-project:
	firefox https://github.com/kaleemullah360/TechToday &

view-profile:
	firefox https://github.com/kaleemullah360 &
