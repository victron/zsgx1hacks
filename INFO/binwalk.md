# binwalk

- `binwalk Hip_Mod_fw.img` just to see what inside
- `binwalk -e Hip_Mod_fw.img` extract all

## filter options
should be in low case
`-y` include, `-x` exclude
- `binwalk -y filesystem -e Hip_Mod_fw_S.img` extract only filesystem
- `binwalk -y squashfs Hip_Mod_fw_S.img`
