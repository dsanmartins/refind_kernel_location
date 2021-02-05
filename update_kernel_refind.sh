#!/bin/bash

#Variables
num=0
check1=0
check2=0
efi_path=/boot/efi/EFI/void/
refind_file=/boot/efi/EFI/refind/refind.conf
old_kernel=($(uname -r))
new_kernel=''

#Get last files of /boot directory
get_last_vmlinuz=$(ls -t /boot/vmlinuz* | head -1)
get_last_initramfs=$(ls -t /boot/initramfs* | head -1)

#Checking new kernel
new_kernel=$(echo $get_last_vmlinuz | cut -d'-' -f 2)
initversion=$(echo $get_last_initramfs | cut -d'-' -f 2| sed 's/.img//' )

if [ $new_kernel != $old_kernel ]
then
	if [ $new_kernel == $initversion ] ; then

		#remove old kernels
		rm -rf /boot/efi/EFI/void/*
	
		echo copying the file $get_last_vmlinuz  to /boot/efi/EFI/void/
		cp $get_last_vmlinuz $efi_path  
		if [ $? != 0 ] ; then
			check1=1
		fi

		echo copying the file $get_last_initramfs to /boot/efi/EFI/void/
		cp $get_last_initramfs $efi_path 
		if [ $? != 0 ] ; then
			check2=1
		fi

		if [ $check1 -eq 1 ] || [ $check2 -eq 1 ] ; then
			echo There is an error in the copy opertation. Please check!.
		else	
			#replace kernel version (all ocurrencies) in refind.conf file.
			echo The version of the old kernel is: $old_kernel 
       		 	echo The version of the new kernel is: $new_kernel
			sed -i "s/$old_kernel/$new_kernel/g" "$refind_file"
			echo The file $refind_file was changed.
		fi
	else
		echo There is an error in the copy opertation. Please check!.
	fi	
else
	echo The kernel was not changed. Nothing to do.
fi
