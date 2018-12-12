require "http"

def checkManifest(url)
  if(url =~ /manifest.mpd/)
    return true
  else
    return false
  end
end

def downloadManifest(url)
  put HTTP.get(url).to_s
end

def main
  puts "Manifest url: "
  manifest = gets.chomp

  if(checkManifest(manifest) == true)
    downloadManifest(manifest)
  else
    puts "This link doesnt have a manifest.mpd"
  end

end

main