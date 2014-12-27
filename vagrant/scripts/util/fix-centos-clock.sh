#!/bin/bash

if [ -r /boot/grub/grub.conf ] ; then
    grep -q "clocksource_failover=acpi_pm" /boot/grub/grub.conf
    if [ $? -ne 0 ]; then
	sed -i /boot/grub/grub.conf \
	    -e 's/kernel.*quiet/& clocksource_failover=acpi_pm/'
	grep -q "clocksource_failover=acpi_pm" /boot/grub/grub.conf
	if [ $? -ne 0 ]; then
	    echo "Failed to setup clocksource_failover"
	    exit 1
	else
	    touch /tmp/.lock.fix-centos-clock
	    exit 0
	fi
    else
	if [ -f /tmp/.lock.fix-centos-clock ] ; then
	    echo "clocksource_failover already setup, pending reboot"
	    exit 0
	else
	    echo "clocksource_failover already setup"
	    exit 2
	fi
    fi
else
    echo "Can't read /boot/grub/grub.conf"
    exit 1
fi
