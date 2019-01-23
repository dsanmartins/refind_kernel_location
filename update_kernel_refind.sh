#!/bin/bash

#Variables
num=0
efi_path=/boot/efi/EFI/void/
refind_file=/boot/efi/EFI/refind/refind.conf
old_kernel=($(uname -r))
new_kernel=''

#remove older kernels
rm -rf /boot/efi/EFI/void/*

#Get last files of /boot directory
last_files=($(find /boot -maxdepth 1 -type f -mtime -1))

#For each file, check the name, version and move to the efi/EFI/void folder
for((i=$num;i<=${#last_files[@]};++i)) do
   if [[ ${last_files[$i]} == *"vmlinuz"* ]]; then
  	echo copying the file ${last_files[$i]} to /boot/efi/EFI/void/
	new_kernel=$(echo ${last_files[$i]} | cut -d'-' -f 2)
	cp ${last_files[$i]} $efi_path  
   fi

   if [[ ${last_files[$i]} == *"initramfs"* ]]; then
  	echo copying the file ${last_files[$i]} to /boot/efi/EFI/void/
	cp ${last_files[$i]} $efi_path 
   fi
done

#replace kernel version (all ocurrencies) in refind.conf file.
echo The old kernel with version: $old_kernel
echo The new kernel with version: $new_kernel
sed -i "s/$old_kernel/$new_kernel/g" "$refind_file"
echo The file $refind_file was changed.
