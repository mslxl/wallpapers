#!/usr/bin/env nix-shell
#! nix-shell -i nu -p "[nushell imagemagick file]"

ls  | where type == file 
    | where { |f|
      let mime = (file --mime-type -b $f.name | lines | first)
      $mime | str starts-with "image"
    } | where { |f|
      let parts = ($f.name | split row ".")
      if ($parts | length) > 1 {
        ($parts | last) != "jpg"
      } else {
        true
      }
    } | each { |f| 
      let parts = ($f.name | split row ".")
      let name = if ($parts | length) > 1 {
        $parts | drop 1 | str join '.'
      } else {
        $parts | first
      }
      let src = $f.name
      let dst = $name + '.jpg'
      print ($src + " -> " + $dst)
      convert $src $dst
      $src
    } | each {|it| rm $it }
