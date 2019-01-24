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
get_last_vmlinuz=$(ls -t /boot/vmlinuz* | head -1)
get_last_initramfs=$(ls -t /boot/initramfs* | head -1)



echo copying the file $get_last_vmlinuz  to /boot/efi/EFI/void/
new_kernel=$(echo $get_last_vmlinuz | cut -d'-' -f 2)
cp $get_last_vmlinuz $efi_path  

echo copying the file $get_last_initramfs to /boot/efi/EFI/void/
cp $get_last_initramfs $efi_path 

#replace kernel version (all ocurrencies) in refind.conf file.
echo The old kernel with version: $old_kernel
echo The new kernel with version: $new_kernel
sed -i "s/$old_kernel/$new_kernel/g" "$refind_file"
echo The file $refind_file was changed.
