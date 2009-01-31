#!/usr/bin/env ruby

info_plist = File.read("Info.plist")
version = info_plist.scan(/<key>CFBundleShortVersionString<\/key>\n\s*<string>(.+?)<\/string>/).first.first

product = "Scribd\\ Uploader"
dist_dir = "build/Install/dist"
app = "#{dist_dir}/#{product}.app"
sla = "Distribution/SLA.r"
img_icon = "Distribution/Disk\\ Image\\ Icon.r"
vol_template = "Distribution/Volume\\ Template"
big_dmg = "#{dist_dir}/#{product}-tmp.dmg"
dmg = "#{dist_dir}/#{product}-#{version}.dmg"

`rm -f #{big_dmg}`
`rm -f #{dmg}`

mount_info = `hdiutil create -size 10m -volname #{product} -fs HFS+ -attach -uid 99 -gid 99 #{big_dmg}`
drive_ident = mount_info.match(/^(\/dev\/.+?)\s+/m)[1]
mountpoint = mount_info.match(/^.+?\s+.+?\s+(\/Volumes\/.+?)$/m)[1]
mountpoint.gsub! ' ', '\\ '

`cp -R #{app} #{mountpoint}/#{product}.app`
`mkdir #{mountpoint}/.background`
`cp #{vol_template}/Background.png #{mountpoint}/.background/dmgBackground.png`
`cp #{vol_template}/Volume\\ Icon.icns #{mountpoint}/.VolumeIcon.icns`
`cp #{vol_template}/DS_Store #{mountpoint}/.DS_Store`

`SetFile -a C #{mountpoint}`

#`ln -s /Applications #{mountpoint}/Applications`

`hdiutil detach #{mountpoint}`
`hdiutil convert #{big_dmg} -format UDZO -o #{dmg}`

`hdiutil unflatten #{dmg}`
`Rez /Developer/Headers/FlatCarbon/*.r #{sla} -a -o #{dmg}`
`hdiutil flatten #{dmg}`

`hdiutil internet-enable -yes #{dmg}`
`rm -f #{big_dmg}`

`Rez #{img_icon} -a -o #{dmg}`
`SetFile -a C #{dmg}`
